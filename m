Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3EPCBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 22:01:43 -0400
Received: from out1.zte.com.cn ([202.103.147.172]:43835 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751887Ab3EPCBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 22:01:42 -0400
In-Reply-To: <519436B7.2050101@linux.intel.com>
References: <000101ce5174$1962bac0$4c283040$@com> <20130515142035.GD11497@suse.de> <OF1450163D.E6FBE6A2-ON48257B6D.00048ADD-48257B6D.00070A58@zte.com.cn> <519436B7.2050101@linux.intel.com>
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
X-KeepSent: 7A810108:AA9BB6C1-48257B6D:000A1424;
 type=4; name=$KeepSent
To: Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, Zhang Yi <wetpzy@gmail.com>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF7A810108.AA9BB6C1-ON48257B6D.000A1424-48257B6D.000B1EC6@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Thu, 16 May 2013 10:00:54 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-05-16 10:00:48
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-MAIL: mse01.zte.com.cn r4G216C1009629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Darren Hart <dvhart@linux.intel.com> wrote on 2013/05/16 09:30:31:

>
> pgoff_t is an unsigned long, and page_to_pfn() returns an unsigned long.
> Since compound_idx can be assigned from page_to_pfn() and it is added
> with index in the return value, unsigned long seems like a better choice
> to me. Is there a specific reason you prefer an int? It might be "fine"
> but it is likely to raise eyebrows whenever someone read through it.
>
No other specific  reason. I just think that int is enough.

