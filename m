Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3I1T6L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:58:11 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42536 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3I1T6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:58:08 -0400
Date: Sat, 28 Sep 2013 21:58:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, wangyijing@huawei.com, fenghua.yu@intel.com,
        tglx@linutronix.de, guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
Message-ID: <20130928195803.GA32081@gmail.com>
References: <20130928082542.GA18198@gmail.com>
 <20130928102305.GA5956@pd.tnic>
 <20130928134449.GB26931@gmail.com>
 <20130928174749.GE5956@pd.tnic>
 <20130928175444.GA4402@gmail.com>
 <20130928180459.GF5956@pd.tnic>
 <20130928181236.GA4999@gmail.com>
 <20130928191500.GG5956@pd.tnic>
 <20130928192545.GB8228@gmail.com>
 <fc8a60d5-a876-4fe5-836f-cd778617003e@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc8a60d5-a876-4fe5-836f-cd778617003e@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> How about:
> 
> m = 10;
> d = 1;
> 
> while ( val >= m ) {
>         m *= 10;
>         d++;
> }
> 
> ... and not have a *divide* in there?

Yeah :-)

> Man, entering code on a cell phone sucks...

Indeed that explains the BASIC style! (and you got the 8-space tabs right 
on a html mailer - wow, that's impressive.)

It's also probably the first time that code entered on an ordinary cell 
phone has gets into the Linux kernel, so it's probably a new Linux 
milestone, in a twisted, sick way. ;-)

Thanks,

	Ingo
