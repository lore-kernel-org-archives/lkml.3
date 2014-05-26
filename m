Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaEZRAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:00:15 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:59862 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaEZRAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:00:11 -0400
Message-ID: <53837317.9000203@linaro.org>
Date: Mon, 26 May 2014 18:00:07 +0100
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
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400849474-7177-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFqfqhnCKA-dMqAfkhQ+cLLhN0vMtwTxB6t+MUju_04O-g@mail.gmail.com>
In-Reply-To: <CAPDyKFqfqhnCKA-dMqAfkhQ+cLLhN0vMtwTxB6t+MUju_04O-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On 26/05/14 10:10, Ulf Hansson wrote:
> Hi Srinivas,
>
>>
>> +static struct variant_data variant_qcom = {
>> +       .fifosize               = 16 * 4,
>> +       .fifohalfsize           = 8 * 4,
>> +       .clkreg                 = MCI_CLK_ENABLE,
>> +       .datalength_bits        = 24,
>> +       .blksz_datactrl4        = true,
>
> You get compile error here.
yes, You are right, I will reorder this patch after the "mmc: mmci: Add 
Qcom datactrl register variant"


Thanks,
srini
>
> Kind regards
> Ulf Hansson
>
