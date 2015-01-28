Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbbA1UMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:12:46 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46178 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbbA1UMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:12:41 -0500
Message-ID: <54C906DE.9070308@collabora.co.uk>
Date: Wed, 28 Jan 2015 16:57:18 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Ulf Hansson <ulf.hansson@linaro.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-mmc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene@kernel.org>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/5] ARM: dts: exynos5250-snow: Enable wifi power-on
References: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk> <1422439819-29854-6-git-send-email-javier.martinez@collabora.co.uk> <54C8EC38.6010702@broadcom.com>
In-Reply-To: <54C8EC38.6010702@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arend,

Thanks for your feedback.

On 01/28/2015 03:03 PM, Arend van Spriel wrote:
> On 01/28/15 11:10, Javier Martinez Canillas wrote:

>>   &dp {
>> @@ -531,17 +538,33 @@
>>   	status = "okay";
>>   	num-slots =<1>;
>>   	broken-cd;
>> +	cap-sdio-irq;
> 
> This seems like an unrelated change, right?
> 

Well, I found that enabling the SDIO IRQ signalling I had the double
of the transfer rate and I didn't think it justified a separate patch
but you are right and I'll split on v2.

> Regards,
> Arend
> 

Best regards,
Javier
