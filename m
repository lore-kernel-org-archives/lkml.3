Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945AbaDVPBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:01:09 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40635 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736AbaDVPBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:01:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140422142613.GA14535@infradead.org>
References: <20140422142419.GD21121@dreric01-Precision-T1600>
	<20140422142613.GA14535@infradead.org>
Date: Tue, 22 Apr 2014 11:01:03 -0400
X-Google-Sender-Auth: ceImxjvXx1XUCCBErN63BJdGkhY
Message-ID: <CA+5PVA7TFXdK-KjbwUtqMPF6=Ot1yhKycg5naV6N_gALWVN7cg@mail.gmail.com>
Subject: Re: [PATCH] Export irq tracepoints for use by kernel modules
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Drew Richardson <drew.richardson@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Ben Greear <greearb@candelatech.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, mathieu.desnoyers@efficios.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:26 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Apr 22, 2014 at 07:24:20AM -0700, Drew Richardson wrote:
>> After commit de7b2973903c6cc50b31ee5682a69b2219b9919d ("tracepoint:
>> Use struct pointer instead of name hash for reg/unreg tracepoints"),
>> any tracepoints used in a kernel module must be exported.
>
> How does this matter given that there aren't any modular users?

We had a bug report about this breaking systemtap type usage[1].  In
there, Matthieu suggested that the new for_each_kernel_tracepoint
interface be used.

Drew, it would have been proper to CC the author of the change you're
referencing on all of your patches to export these symbols.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1087623
