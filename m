Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab3K1DC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:02:58 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:65479 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3K1DCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:02:55 -0500
Date: Wed, 27 Nov 2013 19:02:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
In-Reply-To: <CAE9FiQUCPvzeiCSan34aV6hfrDHdV=sfHug0tMaAgpOMbum7jw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311271902230.5120@chino.kir.corp.google.com>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net> <tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org> <CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com> <20131121150344.GG10022@twins.programming.kicks-ass.net>
 <CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com> <CAE9FiQUCPvzeiCSan34aV6hfrDHdV=sfHug0tMaAgpOMbum7jw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013, Yinghai Lu wrote:

> original one in linus's tree:
> 
> [    8.952728] NMI watchdog: enabled on all CPUs, permanently consumes
> one hw-PMU counter.
> [    8.965697] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000010
> [    8.969495] IP: [<ffffffff810d7b53>] update_group_power+0x1d3/0x250

This should have been fixed by Srikar's patch, no?
