Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaGaGfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:35:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46969 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaGaGfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:35:31 -0400
Message-ID: <53D9E41A.5040403@ti.com>
Date: Thu, 31 Jul 2014 09:37:14 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: ti: clk-7xx: Correct ABE DPLL configuration
References: <1396446525-20302-1-git-send-email-peter.ujfalusi@ti.com> <5358D534.2070205@ti.com> <535927DF.90404@ti.com> <5368E604.4040107@ti.com> <53C3AC94.5050904@ti.com> <20140729062748.4906.1529@quantum> <53D759E6.3060607@ti.com> <CAPtuhTjMAZcHecO0dr+3zDurCfQH32pmYUQ+zNXhRdS_+vJZsg@mail.gmail.com> <53D8886A.5020600@ti.com> <53D8E49B.3040600@ti.com> <20140730224257.11617.85064@quantum>
In-Reply-To: <20140730224257.11617.85064@quantum>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 01:42 AM, Mike Turquette wrote:
> Quoting Tero Kristo (2014-07-30 05:27:07)
>> On 07/30/2014 08:53 AM, Peter Ujfalusi wrote:
>>> On 07/29/2014 07:12 PM, Mike Turquette wrote:
>>>>> Oh yea, seems this got lost into the myriad of branches I have. I can push
>>>>> this on top of my for-v3.17/ti-clk-drv if you like.
>>>>
>>>> That is the easiest thing for me. I think that Peter wanted to take
>>>> this as a fix for 3.16 though. Peter is that correct?
>>>
>>> Yes, it would have been better to have it in 3.16 along with the DRA7 ATL
>>> clock driver. W/O this patch the ATL will not going to be usable since the ABE
>>> DPLL is set too high to be usable for it's purpose.
>>>
>>
>> Ok, this is now pushed on top of the for-v3.17/ti-clk-driver branch in
>> my git-repo. Mike, do you want a new pull-req for this just in case?
>
> I've picked it manually and applied on top of 3.16-rc7 for a last minute
> fix. I can add your Ack if you like.

Ok thanks, Add my ack if you wish, no need from my side.

-Tero
