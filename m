Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaB0KhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:37:05 -0500
Received: from mx.treblig.org ([80.68.94.177]:41249 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaB0KhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:37:02 -0500
X-Greylist: delayed 1852 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 05:37:02 EST
Date: Thu, 27 Feb 2014 09:56:35 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
Message-ID: <20140227095635.GA1816@gallifrey>
References: <530E6F76.1070605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530E6F76.1070605@zytor.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/3.2.2-kvm-i386-20120306 (i686)
X-Uptime: 09:50:38 up 25 days,  3:34,  1 user,  load average: 0.00, 0.01, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> The number of sparse errors in the current kernel is staggering, and it
> makes sparse a lot less valuable of a tool that it otherwise could be.
> On a build of x86-64 allyesconfig I'm getting 20,676 sparse messages.
> Out of those, 12,358 come from linux/err.h.  Given that the latter
> basically spams *everything*, I can only conclude that almost noone uses
> sparse unless they have a filter script.

I did a bit of sparse fixing a few years ago; my strategy then was to
get used to which types of warnings were more likely to be real
and ignore all the rest - it was the only way to find anything useful from
them.

There were some that were very fruitful; the warnings for gfp_t types were
great at spotting where someone had swapped the parameters to kmalloc
for example.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
