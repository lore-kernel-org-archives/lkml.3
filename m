Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab3I2Ppq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 11:45:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55502 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3I2Ppn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 11:45:43 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130929091453.GA5426@pd.tnic>
References: <20130928180459.GF5956@pd.tnic> <20130928181236.GA4999@gmail.com> <20130928191500.GG5956@pd.tnic> <20130928192545.GB8228@gmail.com> <fc8a60d5-a876-4fe5-836f-cd778617003e@email.android.com> <20130928194927.GI5956@pd.tnic> <20130928195448.GJ5956@pd.tnic> <20130928195833.GB32081@gmail.com> <20130928200838.GK5956@pd.tnic> <6c689698-aaa0-48cc-8e6e-93d9059c0c34@email.android.com> <20130929091453.GA5426@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 29 Sep 2013 08:44:56 -0700
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, wangyijing@huawei.com, fenghua.yu@intel.com,
        tglx@linutronix.de, guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Message-ID: <a4c8ed48-24c3-437e-9f06-e42a8b7a80f4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the goal is to feed this to the field width in printf, which I would think would be the dominant use, then you do have to account for the minus sign.

Borislav Petkov <bp@alien8.de> wrote:
>On Sat, Sep 28, 2013 at 04:13:29PM -0700, H. Peter Anvin wrote:
>> For negative numbers presumably we need to d++ for the minus sign,
>no?
>
>That's easy - the function is called num_digits, so we count only
>digits.
>
>The real question is, is there a use case where we would need to count
>the sign too or only the digits?
>
>And since I can't be clairvoyant, I'll leave it to future generations
>to
>decide what to do with the sign.
>
>:-)

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
