Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab3FMPUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab3FMPUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:20:30 -0400
Date: Thu, 13 Jun 2013 17:15:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 0/3] hw_breakpoint: cleanups
Message-ID: <20130613151546.GA30062@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130601194526.GA27149@redhat.com> <20130613140112.GB16339@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613140112.GB16339@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13, Frederic Weisbecker wrote:
>
> On Sat, Jun 01, 2013 at 09:45:26PM +0200, Oleg Nesterov wrote:
> > Hello.
> >
> > Cleanups, on top of
> >
> > 	[PATCH 0/2]: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c
>
> So this series doesn't have the fix for the warning?

I don't understand the question ;)

The previous series

	[PATCH 1/2] hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
	[PATCH 2/2] hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

tried to fix the bugs which lead to this (correct) warning.

This and the next one try to cleanup the code.

Oleg.

