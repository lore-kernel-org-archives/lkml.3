Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3HALYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:24:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:41473 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3HALYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:24:09 -0400
Date: Thu, 1 Aug 2013 13:24:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.10.4-rt1
Message-ID: <alpine.DEB.2.02.1308011215160.4089@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the 3.10.4-rt1 patch set.

This is a mostly straight forward port of the 3.8 set. I had
experimented with a new implementation detail, but I did not get it
into a shape which would have made it applicable to RT.

Known issues:

      - SLAB support not working

      - Untested on ARM and PPC (hapless victims^W^Wtesters are
        welcome)

I'm about to leave for my annual kids summer camp kitchen duty, so I
let you fool around with the current pile.

Sebastian will help out while I'm away, so please send tons of patches
in the next couple of days and get this thing fixed before I
return. All I'm going to look for in my mail backlog is a mail with
the subject: 3.10.x-rty is perfect :)

The RT patch against 3.10.4 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.10.4-rt1.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.10.4-rt1.tar.xz

Enjoy,

        tglx

