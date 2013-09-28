Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3I1Ttg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:49:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58896 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab3I1Ttd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:49:33 -0400
Date: Sat, 28 Sep 2013 21:49:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, wangyijing@huawei.com, fenghua.yu@intel.com,
        tglx@linutronix.de, guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
Message-ID: <20130928194927.GI5956@pd.tnic>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fc8a60d5-a876-4fe5-836f-cd778617003e@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 12:42:37PM -0700, H. Peter Anvin wrote:
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

Yep, I know why :-)

And yes, that one works too.

> Man, entering code on a cell phone sucks...

Haha, that's why your variables are single letters :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
