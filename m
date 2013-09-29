Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3I2JPD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 05:15:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49214 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab3I2JO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 05:14:59 -0400
Date: Sun, 29 Sep 2013 11:14:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, wangyijing@huawei.com, fenghua.yu@intel.com,
        tglx@linutronix.de, guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
Message-ID: <20130929091453.GA5426@pd.tnic>
References: <20130928180459.GF5956@pd.tnic>
 <20130928181236.GA4999@gmail.com>
 <20130928191500.GG5956@pd.tnic>
 <20130928192545.GB8228@gmail.com>
 <fc8a60d5-a876-4fe5-836f-cd778617003e@email.android.com>
 <20130928194927.GI5956@pd.tnic>
 <20130928195448.GJ5956@pd.tnic>
 <20130928195833.GB32081@gmail.com>
 <20130928200838.GK5956@pd.tnic>
 <6c689698-aaa0-48cc-8e6e-93d9059c0c34@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6c689698-aaa0-48cc-8e6e-93d9059c0c34@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 04:13:29PM -0700, H. Peter Anvin wrote:
> For negative numbers presumably we need to d++ for the minus sign, no?

That's easy - the function is called num_digits, so we count only digits.

The real question is, is there a use case where we would need to count
the sign too or only the digits?

And since I can't be clairvoyant, I'll leave it to future generations to
decide what to do with the sign.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
