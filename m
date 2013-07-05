Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab3GEUhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:37:52 -0400
Received: from mail-gh0-f182.google.com ([209.85.160.182]:56205 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3GEUhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:37:51 -0400
Date: Fri, 5 Jul 2013 17:37:43 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        jolsa@redhat.com, ak@linux.intel.com, zheng.z.yan@intel.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH] perf stat: fix per-socket output bug for uncore events
Message-ID: <20130705203743.GB16414@ghostprotocols.net>
References: <20130705170645.GA32519@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130705170645.GA32519@quad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 05, 2013 at 07:06:45PM +0200, Stephane Eranian escreveu:
> 
> This patch fixes a problem reported by Andi Kleen on perf
> stat when measuring uncore events:
> 
>  # perf stat --per-socket -e uncore_pcu/event=0x0/ -I1000  -a sleep 2
> 
> It would not report counts for the second socket. That was due to a
> cpu mapping bug in print_aggr().
> 
> This patch also fixes the socket numbering bug for <not counted>
> events.
> 
> Reported-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks, applied.

- Arnaldo
