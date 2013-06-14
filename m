Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3FNKWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 06:22:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39814 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3FNKWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 06:22:30 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "vinashphilip@ti.com" <vinashphilip@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: RE: [PATCH v2 0/4] GPIO DT support for da850
Thread-Topic: [PATCH v2 0/4] GPIO DT support for da850
Thread-Index: AQHOaONbqGo6K+v3eEakfe/huCFFO5k0/lxg
Date: Fri, 14 Jun 2013 10:20:43 +0000
Deferred-Delivery: Fri, 14 Jun 2013 10:20:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EADAFCF@DBDE04.ent.ti.com>
References: <1371203020-15092-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1371203020-15092-1-git-send-email-avinashphilip@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 15:13:36, Philip, Avinash wrote:
> With conversion of GPIO davinci driver to platform driver, gpio-davinci driver
> can support DT boot.
> This patch series
> - adds dt binding support for gpio-davinci.
> - da850 dt support goio.
> 
> This patch series is based on Linux 3.10-rc4 and is availabel at [1].
> 
> 1. https://github.com/avinashphilip/am335x_linux/tree/linux_davinci_v3.10_soc_gpio_v310-rc4


This patch series has dependency on [PATCH v2 0/7] Convert GPIO Davinci to platform driver

https://lkml.org/lkml/2013/6/14/120

Thanks
Avinash

> 
> KV Sujith (3):
>   gpio: davinci: DT changes for driver
>   ARM: davinci: da850: add GPIO DT entries
>   ARM: davinci: da850 evm: add GPIO DT data
> 
> Philip Avinash (1):
>   ARM: davinci: da850: Use #include for all device trees
> 
>  .../devicetree/bindings/gpio/gpio-davinci.txt      |   32 +++++++++++
>  arch/arm/boot/dts/da850-enbw-cmc.dts               |    2 +-
>  arch/arm/boot/dts/da850-evm.dts                    |   21 +++++++-
>  arch/arm/boot/dts/da850.dtsi                       |   17 +++++-
>  drivers/gpio/gpio-davinci.c                        |   57 ++++++++++++++++++--
>  5 files changed, 123 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> 
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 

