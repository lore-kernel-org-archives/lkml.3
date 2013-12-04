Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab3LDQnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:43:21 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:55573 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932508Ab3LDQnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:43:19 -0500
Date: Wed, 4 Dec 2013 16:43:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/41] percpu: Consistent per cpu operations V1
In-Reply-To: <20131204084020.GB31737@gmail.com>
Message-ID: <00000142be7e005c-7ec3b0da-e975-438e-9203-7fa7ed80c891-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131204084020.GB31737@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Ingo Molnar wrote:

>
> * Christoph Lameter <cl@linux.com> wrote:
>
> > The kernel has never been audited to ensure that this_cpu operations
> > are consistently used throughout the kernel. The code generated in
> > many places can be improved through the use of this_cpu operations
> > (which uses a segment register for relocation of per cpu offsets
> > instead of performing address calculations).
>
> Your series lacks the this_cpu ops preempt debugging patches that you
> worked on before, what happened to them?

They are included. Please read the complete description. Patches 13 14 and
18 implement the preemption checks.

> Those debug facilities caught kernel real bugs and they are thus
> essential before any percpu extension can be done.

Yes please apply the preemptiopn debug patches included in this series
ASAP.

