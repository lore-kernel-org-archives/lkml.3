Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3FMOBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:01:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39985 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3FMOBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 10:01:17 -0400
Date: Thu, 13 Jun 2013 16:01:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 0/3] hw_breakpoint: cleanups
Message-ID: <20130613140112.GB16339@somewhere>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601194526.GA27149@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601194526.GA27149@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 09:45:26PM +0200, Oleg Nesterov wrote:
> Hello.
> 
> Cleanups, on top of
> 
> 	[PATCH 0/2]: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c

So this series doesn't have the fix for the warning?

> 
> series.
> 
> Oleg.
> 
>  kernel/events/hw_breakpoint.c |   91 ++++++++++++++++-------------------------
>  1 files changed, 35 insertions(+), 56 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
