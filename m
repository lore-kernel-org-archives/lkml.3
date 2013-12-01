Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3LAW0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 17:26:36 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:51827 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab3LAW0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 17:26:11 -0500
X-Spam-Flag: NO
Message-ID: <529BB74C.4000702@pavlinux.ru>
Date: Mon, 02 Dec 2013 02:25:16 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131118 Thunderbird/17.0.11
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.1-rt4
References: <20131116194633.GD11518@linutronix.de> <20131122211119.GL8698@linutronix.de>
In-Reply-To: <20131122211119.GL8698@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-DCC-STREAM-Metrics: ss27-so03.mtu.ru 10001; Body=6 Fuz1=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------[ cut here ]------------
WARNING: CPU: 1 PID: 10 at kernel/time/tick-sched.c:191 0xffffffff8107bac6()
NO_HZ FULL will not work with unstable sched clock
Modules linked in:
CPU: 1 PID: 10 Comm: rcuop/0 Not tainted 3.12.2-rt4 #3
Hardware name: TYAN Computer Corp. S2895/S2895, BIOS 2004Q3 11/18/2008
 0000000000000009 ffff88027fc83ea8 ffffffff81501a58 0000000000000039
 ffff88027fc83ef8 ffff88027fc83ee8 ffffffff8102f992 0000000000012700
ata3.00: configured for UDMA/100
 ffff88027fc8d580 0000000000000001 ffff880272894020 ffff88027fc0d700
Call Trace:
 <IRQ>  [<ffffffff81501a58>] 0xffffffff81501a58
 [<ffffffff8102f992>] 0xffffffff8102f992
 [<ffffffff8102fa61>] 0xffffffff8102fa61
 [<ffffffff8107bac6>] 0xffffffff8107bac6
 [<ffffffff8107c8f4>] 0xffffffff8107c8f4
 [<ffffffff8103405d>] 0xffffffff8103405d
 [<ffffffff81006fff>] 0xffffffff81006fff
 [<ffffffff815085f7>] 0xffffffff815085f7
 <EOI>  [<ffffffff81007083>] ? 0xffffffff81007083
 [<ffffffff81506865>] ? 0xffffffff81506865
 [<ffffffff81095961>] ? 0xffffffff81095961
 [<ffffffff81095860>] ? 0xffffffff81095860
 [<ffffffff8104d0dd>] 0xffffffff8104d0dd
 [<ffffffff8104d030>] ? 0xffffffff8104d030
 [<ffffffff8150763c>] 0xffffffff8150763c
 [<ffffffff8104d030>] ? 0xffffffff8104d030
---[ end trace 53ca152639ff2a59 ]---


