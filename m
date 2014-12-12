Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaLLXYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:24:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:37644 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaLLXYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:24:09 -0500
Date: Sat, 13 Dec 2014 00:24:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Maintainer abuse
Message-ID: <alpine.DEB.2.11.1412130016090.16494@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm really starting to get seriously grumpy about this.

Everyone is aware that we are in the middle of the merge window. So
this is definetely NOT the time to send anything else than urgent
bugfixes or the usual question/reply on something which was discussed
before.

I really consider it to be maintainer abuse to have

  [PATCH V5 00/23] Generic BMIPS kernel
  [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit kernels
  [v3 00/26] Add VT-d Posted-Interrupts support

i.e. 57 patches to look at in my inbox TODAY in the middle of the
merge window where I have to make other really more urgent
decisions.

Not to talk about the other patch series which arrived in the past few
days after the merge window opened. That sums up to a total of more
than 200 patches, some of them superseeded by now.

Nothing of this is 3.19 material so posting it right now is just
useless. I'm not going to look at it and I'm not going to look at it
next week either.

This whole featuritis driven 'post crap as fast as you can' thing has
to stop, really. I'm observing the following patterns in a
frightingly increasing way:

 - Posting of massive patch sets right during or just before the merge
   window

 - Reposting of patchsets before the reviewer/maintainer had a chance
   to reply to ALL of N patches

This really has to stop.

Yours grumpy

      tglx


     

