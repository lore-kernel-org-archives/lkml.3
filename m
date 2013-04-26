Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549Ab3DZJde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:33:34 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:57345 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab3DZJdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:33:31 -0400
Date: Fri, 26 Apr 2013 11:33:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Li, Fei" <fei.li@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "tomoki.sekiyama.qu@hitachi.com" <tomoki.sekiyama.qu@hitachi.com>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: eliminate irq_mis_count counted in arch_irq_stat
Message-ID: <20130426093327.GA1933@gmail.com>
References: <1366962971.32469.4.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <20130426081915.GA1450@gmail.com>
 <BEC9F67575FA1E429CA7CF5AE9BE3634433D23@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BEC9F67575FA1E429CA7CF5AE9BE3634433D23@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li, Fei <fei.li@intel.com> wrote:

> > > Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
> > > Signed-off-by: Li Fei <fei.li@intel.com>
> > 
> > The patch looks good, but this is not a valid signoff sequence. If Liu
> > Chuansheng wrote this patch then his From: line should be included. If he
> > acked it, then it should be added as Acked-by.
> > 
> Hello Ingo,
>    Thanks for your quick feedback. 
> 
>    I add Chuansheng's signature basing on:
>    1> Chuansheng found such hole in code;
>    2> After discussion with Chuansheng, I wrote the patch;
>    3> Chuansheng also acked it.
>    
>    Do you think it's OK to add Chuansheng's signature in such case?
>    Or better suggestion?

Signed-off-by has a specific meaning, it typically means someone authored 
or as a maintainer forwarded the code (which did not happen here) - see 
the details in Documentation/SubmittingPatches, under this section:

  12) Sign your work

If Chuansheng found the bug, there's a Reported-by tag. If Chuansheng 
approves of the fix patch then there's Acked-by for that. If he tested it, 
then for that there's the Tested-by tag. You can also add several of those 
tags.

Thanks,

	Ingo
