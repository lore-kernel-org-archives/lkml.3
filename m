Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3FBIry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 04:47:54 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62894 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3FBIrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 04:47:46 -0400
Date: Sun, 2 Jun 2013 17:45:31 +0900 (PWT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 3.10-rc4
Message-ID: <alpine.LFD.2.03.1306021745220.6129@pixel.linux-foundation.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another week, another -rc. But this time (at least for now) only as a git 
tree - for people actually using the tar-balls and patches, I apologize, 
but I'm a complete moron, and didn't install kup, its perl dependencies, 
and my kup release scripts on the pixel before the trip.

And while I can read and write email, and git is fine with just a few 
(flaky) kB/s internet throughput I have access to right now, installing 
the perl packages etc seems to be a pipe dream.

I suspect nobody actually uses the tar-balls and patches, since git is so 
much more convenient and efficient, so hopefully nobody cares. But I'll 
rectify the lack eventually. Hopefully within a day or two, as my "yum 
update" actually completes. And if not in a day or two, then when I get 
back home a few days later.

Anyway, rc4 is smaller than rc3 (yay!).  But it could certainly be smaller 
still (boo!). There's the usual gaggle of driver fixes (drm, pinctrl, scsi 
target, fbdev, xen), but also filesystems (cifs, xfs, with small fixes to 
reiserfs and nfs).

And arch updates: m68k (mostly defconfig updates), powerpc, arm and x86.

Go forth and test.

                           Linus
