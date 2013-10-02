Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3JBPLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:11:18 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:43543 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121Ab3JBPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:11:13 -0400
Date: Wed, 2 Oct 2013 15:11:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu
 ops
In-Reply-To: <20130928083952.GB26167@gmail.com>
Message-ID: <0000014179b908eb-29821dc1-7b08-4dd5-b86b-a88c00864249-000000@email.amazonses.com>
References: <20130924154159.855373283@linux.com> <0000014150a21408-2d759c49-6a9e-4553-956f-2d4b53e710f8-000000@email.amazonses.com> <20130924171029.GB10261@gmail.com> <0000014155fdd6cf-d54da8b8-2198-40ce-8831-4559971e69f0-000000@email.amazonses.com>
 <20130925181146.GA16693@gmail.com> <000001415fb34afc-79a24112-5d3f-431c-b90c-d6cfa1caf27a-000000@email.amazonses.com> <20130928083952.GB26167@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.02-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Sep 2013, Ingo Molnar wrote:

>
> * Christoph Lameter <cl@linux.com> wrote:
>
> > On Wed, 25 Sep 2013, Ingo Molnar wrote:
> >
> > > >
> > > > I think this is necessary since it seems that the discussions on how
> > > > to do the raw_cpu conversions may take some time. If we enable it by
> > > > default then there will be numerous new log messages. That way a
> > > > developer can enable it for working on this.
> > >
> > > Note that for these patches to be eligible for upstream merge any
> > > extra warnings that trigger must be fixed, regardless of the default
> > > setting.
> >
> > That is exactly what this patch does. There will only be warning if the
> > user enabled them.
>
> You didn't understand me apparently: all warnings that trigger with the
> debug CONFIG option enabled must be fixed before this can be sent
> upstream.

This patchset is required to determine the warnings that will be triggered
and to get the work to address these issues done. The feedback so far
indicates that there may be lots of discussions regarding the warnings
that have been discovered so far. Its not realistic to do this in one go.




