Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaHUVDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:03:50 -0400
Received: from www.sr71.net ([198.145.64.142]:48427 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbaHUVDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:03:49 -0400
Message-ID: <53F65EB3.5060209@sr71.net>
Date: Thu, 21 Aug 2014 14:03:47 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com, peterz@infradead.org, mingo@redhat.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, lauraa@codeaurora.org
Subject: Re: [PATCH] [v3] warn on performance-impacting configs aka. TAINT_PERFORMANCE
References: <20140821202424.7ED66A50@viggo.jf.intel.com> <20140821205727.GA7200@redhat.com>
In-Reply-To: <20140821205727.GA7200@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 01:57 PM, Dave Jones wrote:
>  > diff -puN kernel/panic.c~taint-performance kernel/panic.c
>  > --- a/kernel/panic.c~taint-performance	2014-08-19 11:38:28.928975233 -0700
>  > +++ b/kernel/panic.c	2014-08-20 09:56:29.528471033 -0700
>  > @@ -225,6 +225,7 @@ static const struct tnt tnts[] = {
>  >  	{ TAINT_OOT_MODULE,		'O', ' ' },
>  >  	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
>  >  	{ TAINT_SOFTLOCKUP,		'L', ' ' },
>  > +	{ TAINT_PERFORMANCE,		'Q', ' ' },
> 
> You don't need these any more.

Bah, thanks for catching that.  I'll wait a bit for any other comments
and send out a fixed version.

