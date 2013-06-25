Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3FYTl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:41:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:58087 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab3FYTl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:41:56 -0400
Date: Tue, 25 Jun 2013 21:41:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Zhang Yi <wetpzy@gmail.com>, linux-kernel@vger.kernel.org,
        "'Mel Gorman'" <mgorman@suse.de>, "'Ingo Molnar'" <mingo@kernel.org>,
        "'Peter Zijlstra'" <peterz@infradead.org>, zhang.yi20@zte.com.cn
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
In-Reply-To: <1372184610.7914.96.camel@envy.home>
Message-ID: <alpine.DEB.2.02.1306252141020.4013@ionos.tec.linutronix.de>
References: <000101ce5174$1962bac0$4c283040$@com>   <20130515142035.GD11497@suse.de>   <OF1450163D.E6FBE6A2-ON48257B6D.00048ADD-48257B6D.00070A58@zte.com.cn>   <519436B7.2050101@linux.intel.com>   <OF7A810108.AA9BB6C1-ON48257B6D.000A1424-48257B6D.000B1EC6@zte.com.cn>
  <1372107737.7914.27.camel@envy.home> <000101ce71a6$a83c5880$f8b50980$@com> <1372184610.7914.96.camel@envy.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013, Darren Hart wrote:
> Otherwise this looks ready to me. Thomas, do you want a resend with
> commit message corrections or do you prefer to integrate those 
> yourself?
> 
> With the above fixes:
> 
> Acked-by: Darren Hart <dvhart@linux.intel.com>

I pick it up and fix it. We delayed it long enough already.

Thanks,

	tglx
