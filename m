Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaE0Ntj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:49:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61292 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaE0Ntg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:49:36 -0400
Message-ID: <538497E4.1070202@linaro.org>
Date: Tue, 27 May 2014 14:49:24 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 03/13] mmc: mmci: Add Qualcomm Id to amba id table
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400849474-7177-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFqfqhnCKA-dMqAfkhQ+cLLhN0vMtwTxB6t+MUju_04O-g@mail.gmail.com> <53837317.9000203@linaro.org>
In-Reply-To: <53837317.9000203@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/05/14 18:00, Srinivas Kandagatla wrote:
> Hi Ulf,
>
> On 26/05/14 10:10, Ulf Hansson wrote:
>> Hi Srinivas,
>>
>>>
>>> +static struct variant_data variant_qcom = {
>>> +       .fifosize               = 16 * 4,
>>> +       .fifohalfsize           = 8 * 4,
>>> +       .clkreg                 = MCI_CLK_ENABLE,
>>> +       .datalength_bits        = 24,
>>> +       .blksz_datactrl4        = true,
>>
>> You get compile error here.
> yes, You are right, I will reorder this patch after the "mmc: mmci: Add
> Qcom datactrl register variant"

Actually, blksz_datactrl4 should not be in this patch. it is part of 
"mmc: mmci: Add Qcom datactrl register variant"  will remove it from 
this patch in next version.

--srini
>
>
> Thanks,
> srini
>>
>> Kind regards
>> Ulf Hansson
>>
