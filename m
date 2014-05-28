Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaE1H1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:27:37 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:59373 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaE1H1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:27:35 -0400
Message-ID: <53858FE3.9040207@linaro.org>
Date: Wed, 28 May 2014 08:27:31 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 08/13] mmc: mmci: add 8bit bus support in variant data
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400849527-7384-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFruVPo-k+19pQ4zGrVBH0gqszQ5vphsTAm6HTXUX5riFg@mail.gmail.com>
In-Reply-To: <CAPDyKFruVPo-k+19pQ4zGrVBH0gqszQ5vphsTAm6HTXUX5riFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus W,


On 26/05/14 11:07, Ulf Hansson wrote:
>>          unsigned int            fifosize;
>> >         unsigned int            fifohalfsize;
>> >@@ -116,6 +118,7 @@ static struct variant_data variant_u300 = {
>> >         .fifosize               = 16 * 4,
>> >         .fifohalfsize           = 8 * 4,
>> >         .clkreg_enable          = MCI_ST_U300_HWFCEN,
>> >+       .clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
> Linus, will have to confirm this. I don't know if the u300 variant
> support 8-bit.
>

Do you know if u300 supports 8BIT bus?

thanks,
srini

> Kind regards
> Ulf Hansson
>
