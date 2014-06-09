Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbaFIN7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:59:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50160 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbaFIN7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:59:52 -0400
Message-ID: <5395BDA7.3060507@ti.com>
Date: Mon, 9 Jun 2014 09:59:03 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@freescale.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] dt/documentation: add specification of dma bus information
References: <1401981720-6946-1-git-send-email-santosh.shilimkar@ti.com> <CAOMZO5Ceg9RpC8Lgt0BwGTuaz-Z2614Die2PrbtT_j4QYjL_sA@mail.gmail.com>
In-Reply-To: <CAOMZO5Ceg9RpC8Lgt0BwGTuaz-Z2614Die2PrbtT_j4QYjL_sA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 June 2014 10:13 PM, Fabio Estevam wrote:
> On Thu, Jun 5, 2014 at 12:22 PM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> Recently we introduced the generic device tree infrastructure for couple of DMA
>> bus parameter, dma-ranges and dma-coherent. Update the documentation so that
>> its useful for future users.
>>
>> The "dma-ranges" property is intended to be used for describing the
>> configuration of DMA bus RAM addresses and its offset w.r.t CPU addresses.
>>
>> The "dma-coherent" property is intended to be used for identifying devices
>> supported coherent DMA operations.
>>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Shawn Guo <shawn.guo@freescale.com>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> ---
>>  Documentation/devicetree/booting-without-of.txt |   60 +++++++++++++++++++++++
>>  1 file changed, 60 insertions(+)
>>
>> diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
>> index 1f013bd..f0120c1 100644
>> --- a/Documentation/devicetree/booting-without-of.txt
>> +++ b/Documentation/devicetree/booting-without-of.txt
>> @@ -51,6 +51,8 @@ Table of Contents
>>
>>    VIII - Specifying device power management information (sleep property)
>>
>> +  VIV - Specifying dma bus information
> 
> "9" in Roman numeral is "IX"
> 
Yeah.. Not sure what I was thinking...

Regards,
Santosh
