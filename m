Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3I1XOZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:14:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50105 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184Ab3I1XOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:14:23 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130928200838.GK5956@pd.tnic>
References: <20130928174749.GE5956@pd.tnic> <20130928175444.GA4402@gmail.com> <20130928180459.GF5956@pd.tnic> <20130928181236.GA4999@gmail.com> <20130928191500.GG5956@pd.tnic> <20130928192545.GB8228@gmail.com> <fc8a60d5-a876-4fe5-836f-cd778617003e@email.android.com> <20130928194927.GI5956@pd.tnic> <20130928195448.GJ5956@pd.tnic> <20130928195833.GB32081@gmail.com> <20130928200838.GK5956@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 28 Sep 2013 16:13:29 -0700
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Message-ID: <6c689698-aaa0-48cc-8e6e-93d9059c0c34@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For negative numbers presumably we need to d++ for the minus sign, no?

Borislav Petkov <bp@alien8.de> wrote:
>On Sat, Sep 28, 2013 at 09:58:33PM +0200, Ingo Molnar wrote:
>> 
>> * Borislav Petkov <bp@alien8.de> wrote:
>> 
>> > On Sat, Sep 28, 2013 at 09:49:27PM +0200, Borislav Petkov wrote:
>> > > And yes, that one works too.
>> > 
>> > Btw, just to be thorough, we could handle negative numbers too:
>> > 
>> > int num_digits(int val)
>> > {
>> >         int m = 10;
>> >         int d = 1;
>> > 
>> >         if (val < 0)
>> >                 val = -val;
>> > 
>> >         while (val >= m) {
>> >                 m *= 10;
>> >                 d++;
>> >         }
>> > 
>> >         return d;
>> > }
>> 
>> I like the cell phone version better!
>
>This *is* the cell phone version + negative numbers handling.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
