/* 
 * Pipeable blob ("abstract" type).
 * 
 * Author: ANybakk
 */

#include "ItemBlob.as";



namespace ANybakk {

  namespace PipeableBlob {



    void onInit(CBlob@ this) {
    
      //No hierarchy call
      
      setTags(this);
      
    }
    
    
    
    void setTags(CBlob@ this) {
    
      this.Tag("isPipeable");
      
    }
    
    
    
    void onTick(CBlob@ this) {
    
      //No hierarchy call
      
    }
    
    
    
    /**
     * Make a pipeable enter a pipe segment
     * 
     * @param   otherBlob   the pipe segment (other blobs will be ignored)
     */
    void enterPipe(CBlob@ this, CBlob@ otherBlob) {
      
      //Check if other is valid and tagged as pipe
      if(otherBlob !is null && otherBlob.hasTag("isPipe")) {
      
        //Store pipe ID
        this.set_netid("enteredPipeID", otherBlob.getNetworkID());
        
        //Obtain a reference to the shape object
        CShape@ shape = this.getShape();
        
        //Disable map collisions
        shape.getConsts().mapCollisions = false;
        
        //Disable blob collisions
        shape.getConsts().collidable = false;
        
        //Disable gravity
        shape.SetGravityScale(0.0f);
        
        //Check if vanilla type
        if(isConsideredPipeableVanilla(this)) {
        
          //TODO: Disable pickup
          
          
        }
        
        //Update flags
        this.Tag("isInPipe");
        this.Tag("wasEnteredPipe"); //For sprite
      
      }
      
    }
    
    
    
    /**
     * Make a pipeable exit a pipe network. Ignored if not actually in a pipe.
     */
    void exitPipe(CBlob@ this) {
      
      if(this.hasTag("isInPipe")) {
      
        //Store pipe ID
        this.set_netid("enteredPipeID", 0);
        
        //Obtain a reference to the shape object
        CShape@ shape = this.getShape();
        
        //Enable map collisions
        shape.getConsts().mapCollisions = true;
        
        //Enable blob collisions
        shape.getConsts().collidable = true;
        
        //Enable gravity
        shape.SetGravityScale(1.0f);
        
        //Set visible
        //this.getSprite().SetVisible(false);
        
        //Update flags
        this.Untag("isInPipe");
        this.Tag("wasExitedPipe"); //For sprite
        
      }
      
    }
    
    
    
    /**
     * Checks if a blob is to be considered pipeable, either if it's tagged 
     * like one, or is a valid vanilla type.
     */
    bool isConsideredPipeable(CBlob@ this) {
    
      //Check if pipeable
      if(this.hasTag("isPipeable")) {
      
        //Finished, return true
        return true;
        
      }
      
      //Lastly, return if valid vanilla
      return isConsideredPipeableVanilla(this);
      
    }
    
    
    
    /**
     * Checks if a blob is to be considered a pipeable vanilla type.
     */
    bool isConsideredPipeableVanilla(CBlob@ this) {
      
      //Iterate through vanilla group name array
      for(int i=0; i<ANybakk::PipeableVariables::VANILLA_PIPEABLE_GROUP_NAMES.length; i++) {
      
        //Check if tagged
        if(this.hasTag(ANybakk::PipeableVariables::VANILLA_PIPEABLE_GROUP_NAMES[i])) {
        
          //Finished, return true
          return true;
          
        }
        
      }
      
      //Lastly, return true if name matches some entry in vanilla name array
      return ANybakk::PipeableVariables::VANILLA_PIPEABLE_NAMES.find(this.getName()) >= 0;
    
    }
    
    
    
  }
  
}