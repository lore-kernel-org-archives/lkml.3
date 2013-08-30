Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3H3HAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:00:12 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:49305 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab3H3HAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:00:11 -0400
Date: Fri, 30 Aug 2013 09:00:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [guv v2 08/31] tracing: Replace __get_cpu_var uses
Message-ID: <20130830070006.GA14099@gmail.com>
References: <20130826204351.725357339@linux.com>
 <00000140bc5f00c2-8e9ffffa-de46-4329-aef3-317c258828bd-000000@email.amazonses.com>
 <20130828154804.20f4dde6@gandalf.local.home>
 <00000140caeda84d-60e4dd5d-f119-4c9f-8d2e-d0d316e241b9-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140caeda84d-60e4dd5d-f119-4c9f-8d2e-d0d316e241b9-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Wed, 28 Aug 2013, Steven Rostedt wrote:
> 
> > You should limit the width of the change log to 76 characters.
> >
> > I fixed it for now.
> 
> Ok. I have to do that to all patches though. Next rollup.

You'll also need to fix the preempt debug checks before spreading 
this_cpu*() uses, as was pointed out to you in the original this_cpu*() 
submission and which you failed to follow up to.

Consider all affected patches NAK-ed until this bug is fixed.

Thanks,

	Ingo
