Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab3LKPM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:12:26 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57284 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3LKPMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:12:25 -0500
Date: Wed, 11 Dec 2013 16:12:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/41] percpu: Add raw_cpu_ops
Message-ID: <20131211151220.GB11048@gmail.com>
References: <20131203233232.928771708@linux.com>
 <20131203233251.745099192@linux.com>
 <20131210153445.GE4610@htj.dyndns.org>
 <20131210154506.GA1884@gmail.com>
 <20131210154951.GF4610@htj.dyndns.org>
 <20131210155546.GD1995@gmail.com>
 <00000142ddb6d07d-f77cfa15-55a5-4806-891e-2d57894fc46b-000000@email.amazonses.com>
 <20131210183133.GC20770@gmail.com>
 <00000142de1ac9a3-d2b5b7fb-25c5-4bec-acbe-8be30a951bbc-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142de1ac9a3-d2b5b7fb-25c5-4bec-acbe-8be30a951bbc-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Tue, 10 Dec 2013, Ingo Molnar wrote:
> 
> > By what is this required - by the previous patch #13?
> 
> Yes its required in order to keep the __this_cpu ops working.
> 
> > Also, the changelog indicates it's two changes - please split the 
> > patch in two if so.
> 
> Well this is how the x86 portions came from Peter. [...]

That's an interesting piece of information, in particular because you 
lost From: PeterZ authorship there, don't do that!

In any case, your reply does not address my review feedback.

Thanks,

	Ingo
