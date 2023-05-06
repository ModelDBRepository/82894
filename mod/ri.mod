COMMENT
Four helpful hints:

1) before calling scale_connection_coef, one must call some NEURON
function (such as ri(x)) that forces calculation of all the connection
coefficients for all the sections.

2) if any diam or L is changed, then one must re-call the
scale_connection_coef procedure again for all compartments AFTER
re-forcing the normal calculation of them via a call to, e.g. ri(x).

3) note that ri(0.5) gives the resistance in mega ohms between 0.5
location and the 0 end and ri(1) gives the resistance in mega ohms
between the 0.5 location and the 1 end.

4) Call with a section access'ed.  Call below with (1,factor) to
change the axial resistance of (a parent's) x=0.5 to x=1 part and call
with (0.5, factor) to change the axial resistance for (a child's) x=0
to x=0.5 part.  Note: factor = current_ri_value/desired__ri_value.

ENDCOMMENT

NEURON { SUFFIX nothing }

VERBATIM
const char* secname();
ENDVERBATIM

VERBATIM
#ifndef _NrnThread
#define _NrnThread NrnThread
#endif
#ifdef NRN_MECHANISM_DATA_IS_SOA
#define get_nnode(sec) _nrn_mechanism_get_nnode(sec)
#define get_node(sec, node_index) _nrn_mechanism_get_node(sec, node_index)
#define get_thread(node) _nrn_mechanism_get_thread(node)
#else
#define get_nnode(sec) sec->nnode
#define get_node(sec, node_index) sec->pnode[node_index]
#define get_thread(node) node->_nt
#endif
ENDVERBATIM

PROCEDURE scale_connection_coef(x, factor) {
VERBATIM {
	Section* sec;
	Node* nd;
#if defined(t)
	_NrnThread* _nt = nrn_threads;
#endif /* t */
	sec = chk_access();
	if (_lx <= 0. || _lx > 1.) {
		hoc_execerror("out of range, must be 0 < x <= 1", (char*)0);
	}
	/*printf("scale_connection_coefs %s(%g) %d\n", secname(sec), _lx, get_nnode(sec));*/
	/* assumes 0 end of child connected to parent */
	if (_lx == 1.) {
		nd = get_node(sec, get_nnode(sec) - 1);
	}else{
		nd = get_node(sec, (int)(_lx*(double)(get_nnode(sec) - 1)));
	}
#if defined(t)        
	_nt = get_thread(nd);
#endif /* t */
	/*printf("%g %g\n", NODEA(nd), NODEB(nd));*/
	NODEA(nd) *= _lfactor;
	NODEB(nd) *= _lfactor;
}
ENDVERBATIM
}
