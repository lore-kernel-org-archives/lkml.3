Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3HDAYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 20:24:49 -0400
Received: from mx.treblig.org ([80.68.94.177]:36727 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab3HDAYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 20:24:48 -0400
X-Greylist: delayed 2553 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Aug 2013 20:24:47 EDT
Date: Sun, 4 Aug 2013 00:42:13 +0100
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Vern Clark <vmclark@verizon.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel causes excessive delay mounting USB device
Message-ID: <20130803234213.GA16298@gallifrey>
References: <20130803153349.63acfab2@u>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130803153349.63acfab2@u>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.36.4-kvm-i386-20110819 (i686)
X-Uptime: 00:36:13 up 84 days,  8:39,  1 user,  load average: 0.01, 0.02, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vern Clark (vmclark@verizon.net) wrote:
> 
> Plugging in any USB flash stick takes 5-6 minutes before its mounted.
> 
> ===
> Using the current kernel-3.8.0-28-generic, the USB fails to load in proper time.
> I found this message in syslog: timeout: killing '/sbin/blkid -o udev -p /dev/sdb'. Right after which, the USB device was mounted.
> 
> Using an earlier kernel-3.2.37-030237-generic, fixed the problem.

Did you try going back to one of their previous 3.8.0 versions rather than a big jump like that?

> Aug  2 09:39:16 u kernel: [ 2269.914570] sd 11:0:0:0: [sdb] Assuming drive cache: write through
> Aug  2 09:39:47 u kernel: [ 2300.739825] usb 1-8: reset high-speed USB device number 11 using ehci-pci

Curious; I've just started getting something similar on the Ubuntu 3.10.0-6 kernels, and 
last nights v3.11-rc3 build.

It's been suggested perhaps:
http://www.spinics.net/lists/stable/msg16022.html

is the culprit, but I haven't tried it yet.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
