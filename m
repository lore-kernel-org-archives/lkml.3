Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab3K1UX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:23:59 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47044 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3K1UX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 15:23:56 -0500
MIME-Version: 1.0
In-Reply-To: <20131128093858.GI10022@twins.programming.kicks-ass.net>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
	<tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
	<CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
	<20131121150344.GG10022@twins.programming.kicks-ass.net>
	<CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
	<CAE9FiQUCPvzeiCSan34aV6hfrDHdV=sfHug0tMaAgpOMbum7jw@mail.gmail.com>
	<alpine.DEB.2.02.1311271902230.5120@chino.kir.corp.google.com>
	<CAE9FiQUVLT3PL3ON_VRrNB6p9TxFU_-X_dkcb6dLvzonmmW7ag@mail.gmail.com>
	<20131128093858.GI10022@twins.programming.kicks-ass.net>
Date: Thu, 28 Nov 2013 12:23:55 -0800
X-Google-Sender-Auth: r_DsPbuTQ0DwjrrZpRXPqqxS5wM
Message-ID: <CAE9FiQUFGLEBSbW124X8Ja7uJG4KcTtQeD+X0nFrWR2ATdK=qg@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 1:38 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Nov 27, 2013 at 11:07:04PM -0800, Yinghai Lu wrote:
>> On Wed, Nov 27, 2013 at 7:02 PM, David Rientjes <rientjes@google.com> wrote:
>> > On Thu, 21 Nov 2013, Yinghai Lu wrote:
>> >
>> >> original one in linus's tree:
>> >>
>> >> [    8.952728] NMI watchdog: enabled on all CPUs, permanently consumes
>> >> one hw-PMU counter.
>> >> [    8.965697] BUG: unable to handle kernel NULL pointer dereference
>> >> at 0000000000000010
>> >> [    8.969495] IP: [<ffffffff810d7b53>] update_group_power+0x1d3/0x250
>> >
>> > This should have been fixed by Srikar's patch, no?
>>
>> maybe not related, now in another system, linus's tree + Srikar's patch.
>
> And this another such -EX system? And from what I can tell its during
> boot, right?

Ivybridge EX, yes.
