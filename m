Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaEWRJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:09:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbaEWRJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:09:11 -0400
Date: Fri, 23 May 2014 14:09:04 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] i8k: increase fan limit to 3
Message-ID: <20140523170904.GA2498@t520.home>
References: <1400725168-21358-1-git-send-email-fbl@redhat.com>
 <20140522151048.GB1001@roeck-us.net>
 <20140522155458.GI12759@t520.home>
 <20140522180023.GB14814@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522180023.GB14814@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 11:00:23AM -0700, Guenter Roeck wrote:
> On Thu, May 22, 2014 at 12:54:58PM -0300, Flavio Leitner wrote:
> > On Thu, May 22, 2014 at 08:10:48AM -0700, Guenter Roeck wrote:
> > > On Wed, May 21, 2014 at 11:19:28PM -0300, Flavio Leitner wrote:
> > > > From: Flavio Leitner <fbl@sysclose.org>
> > I volunteer to test on precision 490n and on latitude D520.
> > 
> Can you send me dmi information for those systems ?
> The output of "grep . /sys/class/dmi/id/*" should do.

490n:
# grep . /sys/class/dmi/id/*
/sys/class/dmi/id/bios_date:05/24/2007
/sys/class/dmi/id/bios_vendor:Dell Inc.                
/sys/class/dmi/id/bios_version:A05
/sys/class/dmi/id/board_name:0GU083
/sys/class/dmi/id/board_serial:..CN1374075H003N.
/sys/class/dmi/id/board_vendor:Dell Inc.          
/sys/class/dmi/id/board_version:A00
/sys/class/dmi/id/chassis_asset_tag:        
/sys/class/dmi/id/chassis_serial:69FS6D1
/sys/class/dmi/id/chassis_type:7
/sys/class/dmi/id/chassis_vendor:Dell Inc.                
/sys/class/dmi/id/modalias:dmi:bvnDellInc.:bvrA05:bd05/24/2007:svnDellInc.:pnPrecisionWorkStation490:pvr:rvnDellInc.:rn0GU083:rvrA00:cvnDellInc.:ct7:cvr:
grep: /sys/class/dmi/id/power: Is a directory
/sys/class/dmi/id/product_name:Precision WorkStation 490    
/sys/class/dmi/id/product_serial:69FS6D1
/sys/class/dmi/id/product_uuid:44454C4C-3900-1046-8053-B6C04F364431
grep: /sys/class/dmi/id/subsystem: Is a directory
/sys/class/dmi/id/sys_vendor:Dell Inc.                
/sys/class/dmi/id/uevent:MODALIAS=dmi:bvnDellInc.:bvrA05:bd05/24/2007:svnDellInc.:pnPrecisionWorkStation490:pvr:rvnDellInc.:rn0GU083:rvrA00:cvnDellInc.:ct7:cvr:


d520:
#  grep . /sys/class/dmi/id/*
/sys/class/dmi/id/bios_date:10/13/2006
/sys/class/dmi/id/bios_vendor:Dell Inc.
/sys/class/dmi/id/bios_version:A02
/sys/class/dmi/id/board_asset_tag:        
/sys/class/dmi/id/board_name:0NF744
/sys/class/dmi/id/board_serial:.JYCM0C1.CN4864368I4174.
/sys/class/dmi/id/board_vendor:Dell Inc.
/sys/class/dmi/id/board_version:   
/sys/class/dmi/id/chassis_serial:JYCM0C1
/sys/class/dmi/id/chassis_type:8
/sys/class/dmi/id/chassis_vendor:Dell Inc.
/sys/class/dmi/id/modalias:dmi:bvnDellInc.:bvrA02:bd10/13/2006:svnDellInc.:pnLatitudeD520:pvr:rvnDellInc.:rn0NF744:rvr:cvnDellInc.:ct8:cvr:
grep: /sys/class/dmi/id/power: Is a directory
/sys/class/dmi/id/product_name:Latitude D520                   
/sys/class/dmi/id/product_serial:JYCM0C1
/sys/class/dmi/id/product_uuid:44454C4C-5900-1043-804D-CAC04F304331
grep: /sys/class/dmi/id/subsystem: Is a directory
/sys/class/dmi/id/sys_vendor:Dell Inc.
/sys/class/dmi/id/uevent:MODALIAS=dmi:bvnDellInc.:bvrA02:bd10/13/2006:svnDellInc.:pnLatitudeD520:pvr:rvnDellInc.:rn0NF744:rvr:cvnDellInc.:ct8:cvr:

fbl
