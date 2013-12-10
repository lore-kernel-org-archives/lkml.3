Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3LJSbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:31:39 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:47735 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3LJSbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:31:37 -0500
Date: Tue, 10 Dec 2013 19:31:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/41] percpu: Add raw_cpu_ops
Message-ID: <20131210183133.GC20770@gmail.com>
References: <20131203233232.928771708@linux.com>
 <20131203233251.745099192@linux.com>
 <20131210153445.GE4610@htj.dyndns.org>
 <20131210154506.GA1884@gmail.com>
 <20131210154951.GF4610@htj.dyndns.org>
 <20131210155546.GD1995@gmail.com>
 <00000142ddb6d07d-f77cfa15-55a5-4806-891e-2d57894fc46b-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142ddb6d07d-f77cfa15-55a5-4806-891e-2d57894fc46b-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Tue, 10 Dec 2013, Ingo Molnar wrote:
> 
> > > Yeah, trying to figure out which should go through which tree.
> > > Christoph, should I also pickup 14?  Or can that go through x86?
> >
> > Well, it appears to have dependencies so I doubt it can be kept
> > separate. In any case, provided all debugging is properly productized:
> 
> 13/14 can be just merged. There are no dependencies on earlier 
> patches.
> 
> If you want to merge 18 then you would need to pick up also 15-17.

So I'm referring to the 'This is required' wording here:

| Subject: [PATCH 14/41] x86: Rename __this_cpu_xxx_# operations to raw_cpu_xxx_#
|
| This is required now since the core portion expects a different 
| naming.
|
| Change the names from __this_cpu_xxxx_# to raw_cpu_xxxx_#.
|
| Also changes the uses of the x86 percpu primitives in preempt.h.
|
| This is required now since the core portion expects a different naming.


By what is this required - by the previous patch #13?

Also, the changelog indicates it's two changes - please split the 
patch in two if so.

(Tejun, please wait for this review to be complete before committing 
anything.)

Thanks,

	Ingo
