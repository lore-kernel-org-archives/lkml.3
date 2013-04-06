Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422886Ab3DFNOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 09:14:42 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40406 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422871Ab3DFNOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 09:14:41 -0400
From: "Michael D. Setzer II" <msetzerii@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Date: Sat, 06 Apr 2013 23:14:35 +1000
MIME-Version: 1.0
Subject: Re: Error in linux-3.0.72 build.
Message-ID: <51601FBB.20534.E2355@msetzerii.gmail.com>
In-reply-to: <20130406124101.GA7816@thunk.org>
References: <515FF835.28644.1FF1E@msetzerii.gmail.com>, <20130406124101.GA7816@thunk.org>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Apr 2013 at 8:41, Theodore Ts'o wrote:

Date sent:      	Sat, 6 Apr 2013 08:41:01 -0400
From:           	Theodore Ts'o <tytso@mit.edu>
To:             	"Michael D. Setzer II" <msetzerii@gmail.com>
Copies to:      	linux-kernel@vger.kernel.org
Subject:        	Re: Error in linux-3.0.72 build.

> On Sat, Apr 06, 2013 at 08:25:57PM +1000, Michael D. Setzer II wrote:
> > Just downloaded new kernels, and find this error in build.
> 
> Patch is here: 
> 
> http://www.spinics.net/lists/linux-ext4/msg37598.html
> 
> Explanation of why it's needed is here:
> 
> http://www.spinics.net/lists/linux-ext4/msg37600.html
> 

Thanks. Made the patch, and it now compiles.

> Greg has queued it for the next stable release.
> 
> Cheers,
> 
> 						- Ted


+----------------------------------------------------------+
  Michael D. Setzer II -  Computer Science Instructor      
  Guam Community College  Computer Center                  
  mailto:mikes@kuentos.guam.net                            
  mailto:msetzerii@gmail.com
  http://www.guam.net/home/mikes
  Guam - Where America's Day Begins                        
  G4L Disk Imaging Project maintainer 
  http://sourceforge.net/projects/g4l/
+----------------------------------------------------------+

http://setiathome.berkeley.edu (Original)
Number of Seti Units Returned:  19,471
Processing time:  32 years, 290 days, 12 hours, 58 minutes
(Total Hours: 287,489)

BOINC@HOME CREDITS
SETI        14361044.287140   |   EINSTEIN    10723942.979852
ROSETTA      6832434.144171   |   ABC         15903532.519753

