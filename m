Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaFYKVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:21:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:26328 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaFYKVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:21:41 -0400
Message-ID: <53AAA2B0.1070103@atmel.com>
Date: Wed, 25 Jun 2014 12:21:36 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] ARM: at91: more clocks fixes for 3.16
References: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/2014 18:41, Alexandre Belloni :
> Hi,
> 
> This patch set fixes more issues with the clocks on AT91:
> 
> The first patch define the slow crystal on the at91sam9261ek board
> 
> The next patchs are moving all the clocks that were under the root under a
> "clocks" node to be consistent accross all architecture.
> 
> Alexandre Belloni (6):
>   ARM: at91/dt: define sam9261ek slow crystal frequency
>   ARM: at91/dt: sam9261 crystals under the clocks node
>   ARM: at91/dt: sam9n12 crystals under the clocks node
>   ARM: at91/dt: sam9rl crystals under the clocks node
>   ARM: at91/dt: sam9x5 crystals under the clocks node
>   ARM: at91/dt: sama5d3 crystals under the clocks node

On the whole series:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
And stacked on 3.16-fixes branch.

Best regards,


>  arch/arm/boot/dts/at91-sama5d3_xplained.dts | 12 +++++++-----
>  arch/arm/boot/dts/at91sam9261.dtsi          | 20 ++++++++++---------
>  arch/arm/boot/dts/at91sam9261ek.dts         | 12 ++++++++----
>  arch/arm/boot/dts/at91sam9n12.dtsi          | 20 ++++++++++---------
>  arch/arm/boot/dts/at91sam9n12ek.dts         | 16 +++++++--------
>  arch/arm/boot/dts/at91sam9rl.dtsi           | 22 ++++++++++-----------
>  arch/arm/boot/dts/at91sam9rlek.dts          | 17 ++++++++--------
>  arch/arm/boot/dts/at91sam9x5.dtsi           | 30 +++++++++++++++--------------
>  arch/arm/boot/dts/at91sam9x5cm.dtsi         | 12 +++++++-----
>  arch/arm/boot/dts/sama5d3.dtsi              | 22 ++++++++++-----------
>  arch/arm/boot/dts/sama5d3xcm.dtsi           | 12 +++++++-----
>  11 files changed, 105 insertions(+), 90 deletions(-)
> 


-- 
Nicolas Ferre
