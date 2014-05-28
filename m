Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaE1HxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:53:14 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:35812 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaE1HxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:53:12 -0400
MIME-Version: 1.0
In-Reply-To: <53858FE3.9040207@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1400849527-7384-1-git-send-email-srinivas.kandagatla@linaro.org>
	<CAPDyKFruVPo-k+19pQ4zGrVBH0gqszQ5vphsTAm6HTXUX5riFg@mail.gmail.com>
	<53858FE3.9040207@linaro.org>
Date: Wed, 28 May 2014 09:53:11 +0200
Message-ID: <CACRpkdaXr99W+ckN11p7K22j4z0ikNFyZE6HUsU4gKhXrm2XPA@mail.gmail.com>
Subject: Re: [PATCH v3 08/13] mmc: mmci: add 8bit bus support in variant data
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 9:27 AM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> Hi Linus W,
> On 26/05/14 11:07, Ulf Hansson wrote:
>>>
>>>          unsigned int            fifosize;
>>> >         unsigned int            fifohalfsize;
>>> >@@ -116,6 +118,7 @@ static struct variant_data variant_u300 = {
>>> >         .fifosize               = 16 * 4,
>>> >         .fifohalfsize           = 8 * 4,
>>> >         .clkreg_enable          = MCI_ST_U300_HWFCEN,
>>> >+       .clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
>>
>> Linus, will have to confirm this. I don't know if the u300 variant
>> support 8-bit.
>>
>
> Do you know if u300 supports 8BIT bus?

Yes it does actually.

Yours,
Linus Walleij
