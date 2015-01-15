Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbbAOOeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:34:15 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:1339 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbbAOOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:34:13 -0500
Message-ID: <54B7CFE4.3060603@atmel.com>
Date: Thu, 15 Jan 2015 15:34:12 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Bo Shen <voice.shen@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] AT91 DT for 3.20 #1
References: <1421172746-18727-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421172746-18727-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/01/2015 19:12, Alexandre Belloni a écrit :
> This series enables RTC on the at91sam9n12 and at91rm9200.
> It also adds nodes for the SRAM availabe on at91 SoCs.
> 
> Finally it adds a dtsi for the at91sam9xe and uses it for the ethernut5 dts.
> 
> Changes in v3:
>  - corrected the 9260 and 9g20 reg properties of the SRAM node
> 
> Changes in v2:
>  - remove the 9x5 errata for the n12 rtc
> 
> Alexandre Belloni (6):
>   ARM: at91/dt: at91sam9n12: Add RTC node
>   ARM: at91/dt: rm9200: add RTC node
>   ARM: at91/dt: at91rm9200ek: enable RTC
>   ARM: at91/dt: add SRAM nodes
>   ARM: at91/dt: Add a dtsi for at91sam9xe
>   ARM: at91/dt: ethernut5: use at91sam9xe.dtsi

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

With the corrected at91sam9rl sram size (0x10000), whole series stacked
on top of at91-3.20-dt.

Thanks.


>  .../devicetree/bindings/arm/atmel-at91.txt         |  1 +
>  arch/arm/boot/dts/at91rm9200.dtsi                  | 12 +++++
>  arch/arm/boot/dts/at91rm9200ek.dts                 |  4 ++
>  arch/arm/boot/dts/at91sam9260.dtsi                 |  5 ++
>  arch/arm/boot/dts/at91sam9261.dtsi                 |  5 ++
>  arch/arm/boot/dts/at91sam9263.dtsi                 | 10 ++++
>  arch/arm/boot/dts/at91sam9g20.dtsi                 |  9 ++++
>  arch/arm/boot/dts/at91sam9g45.dtsi                 |  7 ++-
>  arch/arm/boot/dts/at91sam9n12.dtsi                 | 12 +++++
>  arch/arm/boot/dts/at91sam9rl.dtsi                  |  5 ++
>  arch/arm/boot/dts/at91sam9x5.dtsi                  |  5 ++
>  arch/arm/boot/dts/at91sam9xe.dtsi                  | 60 ++++++++++++++++++++++
>  arch/arm/boot/dts/ethernut5.dts                    |  2 +-
>  arch/arm/boot/dts/sama5d3.dtsi                     |  5 ++
>  arch/arm/boot/dts/sama5d4.dtsi                     |  5 ++
>  15 files changed, 144 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/boot/dts/at91sam9xe.dtsi
> 


-- 
Nicolas Ferre
