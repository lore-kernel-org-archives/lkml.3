Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3H0Pjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:39:49 -0400
Received: from a10-63.smtp-out.amazonses.com ([54.240.10.63]:32774 "EHLO
	a10-63.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570Ab3H0Pjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:39:47 -0400
Date: Tue, 27 Aug 2013 15:39:46 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [guv 00/16] [RFC] percpu: Replace __get_cpu_var uses throughout
 the kernel
In-Reply-To: <20130827145738.92ade046470e4f1887d54cbf@canb.auug.org.au>
Message-ID: <00000140c06e3bb2-08a0bbe9-d7dd-4130-a65e-283f36ffb6f0-000000@email.amazonses.com>
References: <00000140ac8debd6-6f9e64f9-1107-4336-91ef-77cdf764b96a-000000@email.amazonses.com> <20130827145738.92ade046470e4f1887d54cbf@canb.auug.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.27-54.240.10.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013, Stephen Rothwell wrote:

> Hi Christoph,
>
> On Fri, 23 Aug 2013 19:01:56 +0000 Christoph Lameter <cl@linux.com> wrote:
> >
> > At the end of the patchset all uses of __get_cpu_var have been removed so the macro is removed too.
>
> However you get these to Linus, please do not do this last step until the
> following merge window.  I can pretty much guarantee that new usages will
> be added between the generation of the patch set and their integration.

Ok then lets hold this particular patch until 3.13.

> Its also helpful (to me, at least) if these can be routed via various
> subsystem trees to lower the number of conflicts ...

Ok will do.

