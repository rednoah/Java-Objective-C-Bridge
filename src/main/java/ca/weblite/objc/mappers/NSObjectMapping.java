package ca.weblite.objc.mappers;

import ca.weblite.objc.Peerable;
import ca.weblite.objc.Proxy;
import ca.weblite.objc.RuntimeUtils;
import ca.weblite.objc.TypeMapping;
import java.util.HashMap;
import java.util.Map;
import static ca.weblite.objc.RuntimeUtils.*;
import com.sun.jna.Pointer;
import ca.weblite.objc.Runtime;
import ca.weblite.objc.jna.PointerTool;

/**
 * <p>NSObjectMapping class.</p>
 *
 * @author shannah
 * @version $Id: $Id
 * @since 1.1
 */
public class NSObjectMapping implements TypeMapping{
    
    
    

    /** {@inheritDoc} */
    @Override
    public Object cToJ(Object cVar, String signature, TypeMapping root) {
        Pointer cObj = Pointer.NULL;
        if ( Pointer.class.isInstance(cVar) ){
            cObj = (Pointer)cVar;
        } else if (long.class.isInstance(cVar) || Long.class.isInstance(cVar) ){
            cObj = new Pointer((Long)cVar);
        } else {
            return cVar;
        }
        if ( (Pointer.NULL == cObj) || (cVar == null) || (cObj == null) || (PointerTool.getPeer(cObj) == 0L ) ){
            return null;
        }
        String clsName = Runtime.INSTANCE.object_getClassName(cObj);
        boolean isString = false;
        if ( "NSString".equals(clsName) || "NSTaggedPointerString".equals(clsName) || "NSMutableString".equals(clsName) || "__NSCFString".equals(clsName)){
            isString = true;
        }
        
        
        if ( isString  ){
            return RuntimeUtils.str(cObj);
        }
        Object peer = RuntimeUtils.getJavaPeer(PointerTool.getPeer(cObj));
        if ( peer == null ){
            return Proxy.load((Pointer)cObj);
        } else {
            return peer;
        }
        
        
        
    }

    /** {@inheritDoc} */
    @Override
    public Object jToC(Object jVar, String signature, TypeMapping root) {
        if ( jVar == null ){
            return Pointer.NULL;
        }
        if ( String.class.isInstance(jVar)){
            return RuntimeUtils.str((String)jVar);
        }
        if ( Peerable.class.isInstance(jVar)){
            return ((Peerable)jVar).getPeer();
        } else {
            return (Pointer)jVar;
        }
    }
    
}
