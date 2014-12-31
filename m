Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaLaORE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 09:17:04 -0500
Received: from mail.wdtv.com ([66.118.69.84]:43358 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaLaORC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 09:17:02 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: apparent loss of continuity in kernel .config?
Date: Wed, 31 Dec 2014 09:16:57 -0500
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201412310916.57808.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Usually, when I build a new kernel, just placing a copy of an older 
versions .config in the unpacked src directory is sufficient that only 
what has been changed has to be answered during a make oldconfig, perhaps 
a couple dozen new features need to be answered yes or no, and I have a 
.config that will usually build me a bootable kernel.  Not any more.

Since my 3.16.0 has been suffering from stalls of up to 2 or 3 minutes 
while both htop and gkrellm continue to report that there is nothing 
hogging the machine, in a general description that matches the Dave Jone 
saga, but w/o the log spew, probably because I don't have extreme 
debugging enabled.

But its strange in how it manifests itself as it will do it from a fresh 
boot, and I get aggravated and reboot, and it doesn't do it till the next 
reboot which may be a month later.  Almost an alternate boot phenomenon.
 
Attempting to go from 3.16.0 to 3.16.7 last night, a make oldconfig 
started from scratch as if there were no .config's in the directory.  I 
stood on the enter key to take the defaults, then ran a make xconfig to 
discover it was totally wrong for an AMD phenom, no networking, no disc 
drivers, video was an old ATI, when there is an nvidia card in it, yadda, 
yadda.

I went thru this exercise 4 times, as I keep a gzipped copy on the config 
that built the kernel version in the boot directory with my build script.
And every time it was the same story.

Obviously I can't, at 80 yo, remember every item in a 28k .config file 
from build to build, so what am I doing wrong that is destroying this 
continuity?

Thanks everybody.

Cheers, Gene Heskett
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>
US V Castleman, SCOTUS, Mar 2014 is grounds for Impeaching SCOTUS
