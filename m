Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbaCLSTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:19:55 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:46963 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491AbaCLSTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:19:54 -0400
Message-ID: <5320A542.5020101@atmel.com>
Date: Wed, 12 Mar 2014 19:19:46 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCHv3 0/8] at91_adc: documentation and device tree cleanups
References: <1394479045-31852-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1394479045-31852-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 20:17, Alexandre Belloni :
> The first patch synchronise the documentation with the actual code and correct
> the example.
> 
> The second patch move the documentation to the correct location (under iio/adc)
> 
> The remaining patches correct the device trees that are using the adc, mainly
> removing unused properties and making the binding compliant with the ePAPR.

On the whole series:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and stacked on at91-3.15-dt.

I think that the little modifications to the documentation can also go
the arm-soc way: there is no fundamental change to the binding, only
more coherence added.

Bye,

> Changes in v3:
>  - also remove the useless atmel,adc-clock-rate
> 
> Changes in v2:
>  - add #address-cells, #size-cells and a reg for each trigger to comply to the
>    ePAPR instead of removing the unit-address.
>  - also correct the atmel,adc-use-external-triggers property name in the
>    documentation and in the device tree that got it wrong.
> 
> Alexandre Belloni (8):
>   Documentation: dt: iio: improve atmel-adc documentation
>   Documentation: dt: iio: move arm/atmel-adc.txt to iio/adc/at91_adc.txt
>   ARM: at91/dt: at91-ariag25: remove useless adc properties
>   ARM: at91/dt: at91sam9260: remove useless adc properties
>   ARM: at91/dt: at91sam9g45: remove useless adc properties
>   ARM: at91/dt: at91sam9x5: remove useless adc properties
>   ARM: at91/dt: sama5d3: remove useless adc properties
>   ARM: at91/dt: at91-cosino: remove useless adc properties
> 
>  .../devicetree/bindings/arm/atmel-adc.txt          | 81 ---------------------
>  .../devicetree/bindings/iio/adc/at91_adc.txt       | 82 ++++++++++++++++++++++
>  arch/arm/boot/dts/at91-ariag25.dts                 |  1 -
>  arch/arm/boot/dts/at91-cosino.dtsi                 |  1 -
>  arch/arm/boot/dts/at91-cosino_mega2560.dts         |  1 -
>  arch/arm/boot/dts/at91sam9260.dtsi                 | 11 +--
>  arch/arm/boot/dts/at91sam9g45.dtsi                 | 11 +--
>  arch/arm/boot/dts/at91sam9x5.dtsi                  | 13 ++--
>  arch/arm/boot/dts/sama5d3.dtsi                     | 13 ++--
>  arch/arm/boot/dts/sama5d3xdm.dtsi                  |  1 -
>  10 files changed, 108 insertions(+), 107 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/arm/atmel-adc.txt
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/at91_adc.txt
> 


-- 
Nicolas Ferre
