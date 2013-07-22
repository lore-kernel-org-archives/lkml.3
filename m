Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab3GVQ7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:59:52 -0400
Received: from www.sr71.net ([198.145.64.142]:34911 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705Ab3GVQ7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:59:51 -0400
Message-ID: <51ED64FC.8090104@sr71.net>
Date: Mon, 22 Jul 2013 09:59:40 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Raghavendra KT <raghavendra.kt.linux@gmail.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [RESEND][PATCH] mm: vmstats: tlb flush counters
References: <20130716234438.C792C316@viggo.jf.intel.com> <CAC4Lta1mHixqfRSJKpydH3X9M_nQPCY3QSD86Tm=cnQ+KxpGYw@mail.gmail.com> <51E95932.5030902@sr71.net> <20130722100605.GA1148@gmail.com>
In-Reply-To: <20130722100605.GA1148@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 03:06 AM, Ingo Molnar wrote:
> Btw., would be nice to also integrate these VM counters into perf as well, 
> as an instrumentation variant/option.
> 
> It could be done in an almost zero overhead fashion using jump-labels I 
> think.
> 
> [ Just in case someone is bored to death and is looking for an interesting 
>   side project ;-) ]

I'd actually been thinking about making them in to tracepoints, but the
tracepoint macros seem to create #include messes if you try to use them
in very common headers.

Agree it would be an interesting side project, though. :)
