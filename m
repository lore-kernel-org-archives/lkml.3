Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbaJVXWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:22:47 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:57902 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933179AbaJVXWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:22:45 -0400
Date: Thu, 23 Oct 2014 02:22:36 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
In-Reply-To: <20141022.163949.1761351331649936601.davem@davemloft.net>
Message-ID: <alpine.LRH.2.11.1410230221360.28745@adalberg.ut.ee>
References: <20141019.003209.2286339581794609198.davem@davemloft.net> <alpine.LRH.2.11.1410191006430.32417@adalberg.ut.ee> <20141020.145746.428441452740929005.davem@davemloft.net> <20141022.163949.1761351331649936601.davem@davemloft.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Whilst I don't have access to my reproducer machine until tomorrow in
> order to test this myself, I wanted to toss this patch your way so you
> could get a head start on me.

Unfortunately it fails earlier during the boot:

[   25.232318] clocksource: mult[53555555] shift[24]
[   25.288559] clockevent: mult[3126e98] shift[32]
[   25.342813] Console: colour dummy device 80x25
[   25.395990] console [tty0] enabled
[   25.436726] bootconsole [earlyprom0] disabled
ERROR: Last Trap: Memory Address not Aligned

ok

-- 
Meelis Roos (mroos@linux.ee)
