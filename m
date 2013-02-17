Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab3BQP3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:29:54 -0500
Received: from mail.wdtv.com ([66.118.69.84]:48198 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab3BQP3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:29:53 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2013 10:29:52 EST
From: Gene Heskett <gheskett@wdtv.com>
To: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        boinc_dev@ssl.berkeley.edu
Subject: Re: shouldn't a non-privileged malformed sprintf crashes the kernel
Date: Sun, 17 Feb 2013 10:23:08 -0500
References: <5120B408.8030806@gmx.de>
In-Reply-To: <5120B408.8030806@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201302171023.08803.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 February 2013, Toralf Förster wrote:
>This is the 2nd time in a row that a stable kernel (3.7.8 currently)
>crashes in such a way that even the sys-rq key doesn't work any longer.
>Found nothing in the log. The screen shot is here [1]. First time this
>issue was reported in [2].
>
>The bug seems to be triggered by the BOINC client - I'm running the alpha
>version of it [3].
>
>I'm wondering whether the sprintf issue discussed in [4] is the trigger
>for the bug (I attached that message here b/c the BOINC devs doesn't
>allow just even read access to the mail archive w/o registering).
>
>
>@boinc_devs
>IMO it would be helpful to store the pid of the BOINC clients to
>stdoutdae.txt too, or where can I find it ?
>
>
>
>[1] http://ompldr.org/vaGh0MQ
>[2] http://thread.gmane.org/gmane.linux.kernel/1438965
>[3] https://boinc.berkeley.edu/dev/forum_thread.php?id=6698#46649
>[4]
>http://lists.ssl.berkeley.edu/mailman/private/boinc_dev/2013-February/01
>9545.html

You are asking for help from the BOINC folks, on a linux list?  Rotsa ruck.
I was in the top 5000 when it was SETI@home, but they let some windows 
folks in & the next thing I knew SETI was shut down unless you ran it via 
the BOINC manager.  But the BOINC thing never learned about nice, and just 
took over the machine so badly I couldn't even type an email.  I worked for 
several days on a wrapper that did use nice, but their next packet 
transition always managed to defeat it.  When I complained, I was told to 
use windows!  Since it was my machine, not theirs, I nuked it off the 
system.

IMO, if they want to use my spare cpu cycles, then they can make an effort 
to get along with linux.  Telling me, when I complained, to use windows, 
was the last straw.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
My views 
<http://www.armchairpatriot.com/What%20Has%20America%20Become.shtml>
God is love, but get it in writing.
		-- Gypsy Rose Lee
I was taught to respect my elders, but its getting 
harder and harder to find any...
