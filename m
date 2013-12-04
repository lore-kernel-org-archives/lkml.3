Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab3LDRCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:02:35 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:57644 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab3LDRCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:02:34 -0500
Date: Wed, 4 Dec 2013 18:02:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/41] percpu: Consistent per cpu operations V1
Message-ID: <20131204170227.GB6415@gmail.com>
References: <20131203233232.928771708@linux.com>
 <20131204084020.GB31737@gmail.com>
 <00000142be7e005c-7ec3b0da-e975-438e-9203-7fa7ed80c891-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142be7e005c-7ec3b0da-e975-438e-9203-7fa7ed80c891-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Wed, 4 Dec 2013, Ingo Molnar wrote:
> 
> >
> > * Christoph Lameter <cl@linux.com> wrote:
> >
> > > The kernel has never been audited to ensure that this_cpu operations
> > > are consistently used throughout the kernel. The code generated in
> > > many places can be improved through the use of this_cpu operations
> > > (which uses a segment register for relocation of per cpu offsets
> > > instead of performing address calculations).
> >
> > Your series lacks the this_cpu ops preempt debugging patches that you
> > worked on before, what happened to them?
> 
> They are included. Please read the complete description. Patches 13 
> 14 and 18 implement the preemption checks.

Indeed I missed them. They should probably go first in the series.

Other than that they are looking fine now.

Thanks,

	Ingo
