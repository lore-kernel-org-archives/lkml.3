Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3I2FLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 01:11:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52000 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab3I2FLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 01:11:52 -0400
Message-ID: <5247B64F.4080100@zytor.com>
Date: Sat, 28 Sep 2013 22:10:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, wangyijing@huawei.com, fenghua.yu@intel.com,
        tglx@linutronix.de, guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -v1.1] x86, boot: Further compress CPUs bootup message
References: <20130928102305.GA5956@pd.tnic> <20130928134449.GB26931@gmail.com> <20130928174749.GE5956@pd.tnic> <20130928175444.GA4402@gmail.com> <20130928180459.GF5956@pd.tnic> <20130928181236.GA4999@gmail.com> <20130928191500.GG5956@pd.tnic> <20130928192545.GB8228@gmail.com> <fc8a60d5-a876-4fe5-836f-cd778617003e@email.android.com> <20130928195803.GA32081@gmail.com> <20130928201053.GL5956@pd.tnic>
In-Reply-To: <20130928201053.GL5956@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2013 01:10 PM, Borislav Petkov wrote:
> On Sat, Sep 28, 2013 at 09:58:04PM +0200, Ingo Molnar wrote:
>> It's also probably the first time that code entered on an ordinary
>> cell phone has gets into the Linux kernel, so it's probably a new
>> Linux milestone, in a twisted, sick way. ;-)
> 
> We could put the following comment *below* the function in
> arch/x86/lib/misc.c:
> 
> /*
>  * Sent from my mobile phone.  Please pardon brevity and lack of formatting.
>  */
> 
> LoooL.
> 

*Snork* ;)

	-hpa

