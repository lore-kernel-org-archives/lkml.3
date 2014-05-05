Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaEEUtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:49:03 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:45268 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbaEEUs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:48:59 -0400
MIME-Version: 1.0
In-Reply-To: <tip-376e242429bf8539ef39a080ac113c8799840b13@git.kernel.org>
References: <20140417081705.26341.96719.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<tip-376e242429bf8539ef39a080ac113c8799840b13@git.kernel.org>
Date: Mon, 5 May 2014 13:48:58 -0700
Message-ID: <CA+8MBb+wUR9ErQQmqCCYoKfUuPV92iLHMxRCBxrP0NW0-YmmGw@mail.gmail.com>
Subject: Re: [tip:perf/kprobes] kprobes: Introduce NOKPROBE_SYMBOL() macro to
 maintain kprobes blacklist
From: Tony Luck <tony.luck@gmail.com>
To: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, rdunlap@infradead.org,
        Jeremy Fitzhardinge <jeremy@goop.org>, Arnd Bergmann <arnd@arndb.de>,
        dl9pf@gmx.de, Andrew Morton <akpm@linux-foundation.org>,
        sparse@chrisli.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        anil.s.keshavamurthy@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        masami.hiramatsu.pt@hitachi.com, Chris Wright <chrisw@sous-sol.org>,
        akataria@vmware.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is in linux-next ("next-20140505") and I see a
bunch of "Failed to find blacklist" messages when booting
on ia64:

Failed to find blacklist 0001013168300000
Failed to find blacklist 0001013000f0a000
Failed to find blacklist 000101315f70a000
Failed to find blacklist 000101324c80a000
Failed to find blacklist 0001013063f0a000
Failed to find blacklist 000101327800a000
Failed to find blacklist 0001013277f0a000
Failed to find blacklist 000101315a70a000
Failed to find blacklist 0001013277e0a000
Failed to find blacklist 000101305a20a000
Failed to find blacklist 0001013277d0a000
Failed to find blacklist 00010130bdc0a000
Failed to find blacklist 00010130dc20a000
Failed to find blacklist 000101309a00a000
Failed to find blacklist 0001013277c0a000
Failed to find blacklist 0001013277b0a000
Failed to find blacklist 0001013277a0a000
Failed to find blacklist 000101327790a000
Failed to find blacklist 000101303140a000
Failed to find blacklist 0001013a3280a000

What do these mean?

-Tony
