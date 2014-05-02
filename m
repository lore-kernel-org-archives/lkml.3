Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaEBLhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:37:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:40146 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaEBLhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:37:06 -0400
Date: Fri, 2 May 2014 13:37:03 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.14-rt1
Message-ID: <20140502113703.GE9178@linutronix.de>
References: <20140411185739.GA6644@linutronix.de>
 <535BFAF0.5090306@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <535BFAF0.5090306@localhost>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fernando Lopez-Lezcano | 2014-04-26 11:29:04 [-0700]:

>Saw this a moment ago (3.14.1 + rt1, Fedora 19 laptop - I think I
>have seen something similar in 3.12.x-r):

Yes, you did: https://lkml.org/lkml/2014/3/7/163
You did not test I've sent. Care to do so?

>Apr 26 11:16:11 localhost kernel: [   96.323248] ------------[ cut
>here ]------------
>Apr 26 11:16:11 localhost kernel: [   96.323262] WARNING: CPU: 0 PID:
>2051 at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
>Apr 26 11:16:11 localhost kernel: [   96.323264] list_del corruption.
>prev->next should be ffff8802101196a0, but was 0000000000000001
>Apr 26 11:16:11 localhost kernel: [   96.323266] Modules linked in:

and please send backtrace information properly formatted. This is
terrible hard to read.

Sebastian
