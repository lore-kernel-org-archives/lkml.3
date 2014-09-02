Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaIBMrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:47:48 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:23029 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaIBMrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:47:47 -0400
Message-ID: <5405BC6E.7010803@atmel.com>
Date: Tue, 2 Sep 2014 14:47:42 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Boris Brezillon" <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 0/7] ARM: at91: update defconfigs
References: <1409647803-8054-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1409647803-8054-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 10:49, Alexandre Belloni :
> Following recent work on the AT91 platforms, update the defconfigs to include
> the new power and reset driver, the ADC and touchscreen driver, the new PWM
> driver using the generic PWM framework.
> 
> Also remove deprecated options like CONFIG_PROC_DEVICETREE,
> CONFIG_SCSI_MULTI_LUN, CONFIG_MII, CONFIG_MTD_CHAR.

Nice: to the whole series:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks.

> Alexandre Belloni (7):
>   ARM: at91: at91_dt: update defconfig
>   ARM: at91: at91sam9260_9g20: update defconfig
>   ARM: at91: at91sam9261_9g10: update defconfig
>   ARM: at91: at91sam9263: update defconfig
>   ARM: at91: at91sam9g45: update defconfig
>   ARM: at91: at91sam9rl: update defconfig
>   ARM: at91: sama5: update defconfig
> 
>  arch/arm/configs/at91_dt_defconfig          | 25 +++++++++++++------------
>  arch/arm/configs/at91sam9260_9g20_defconfig | 13 +++++--------
>  arch/arm/configs/at91sam9261_9g10_defconfig |  5 ++---
>  arch/arm/configs/at91sam9263_defconfig      | 13 ++++++-------
>  arch/arm/configs/at91sam9g45_defconfig      | 19 +++++++++++--------
>  arch/arm/configs/at91sam9rl_defconfig       | 19 ++++++++++++++-----
>  arch/arm/configs/sama5_defconfig            | 12 ++++++------
>  7 files changed, 57 insertions(+), 49 deletions(-)
> 


-- 
Nicolas Ferre
