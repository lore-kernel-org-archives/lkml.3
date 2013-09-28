Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3I1Ij7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 04:39:59 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:51517 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab3I1Ij4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 04:39:56 -0400
Date: Sat, 28 Sep 2013 10:39:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20130928083952.GB26167@gmail.com>
References: <20130924154159.855373283@linux.com>
 <0000014150a21408-2d759c49-6a9e-4553-956f-2d4b53e710f8-000000@email.amazonses.com>
 <20130924171029.GB10261@gmail.com>
 <0000014155fdd6cf-d54da8b8-2198-40ce-8831-4559971e69f0-000000@email.amazonses.com>
 <20130925181146.GA16693@gmail.com>
 <000001415fb34afc-79a24112-5d3f-431c-b90c-d6cfa1caf27a-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001415fb34afc-79a24112-5d3f-431c-b90c-d6cfa1caf27a-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Wed, 25 Sep 2013, Ingo Molnar wrote:
> 
> > >
> > > I think this is necessary since it seems that the discussions on how 
> > > to do the raw_cpu conversions may take some time. If we enable it by 
> > > default then there will be numerous new log messages. That way a 
> > > developer can enable it for working on this.
> >
> > Note that for these patches to be eligible for upstream merge any 
> > extra warnings that trigger must be fixed, regardless of the default 
> > setting.
> 
> That is exactly what this patch does. There will only be warning if the 
> user enabled them.

You didn't understand me apparently: all warnings that trigger with the 
debug CONFIG option enabled must be fixed before this can be sent 
upstream.

Thanks,

	Ingo
