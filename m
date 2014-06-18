Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445AbaFRH3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:29:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51115 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932665AbaFRH3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:29:18 -0400
Message-ID: <53A13FCC.6060906@free-electrons.com>
Date: Wed, 18 Jun 2014 09:29:16 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] ARM: at91: more clocks fixes for 3.16
References: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1403023308-20533-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 17/06/2014 18:41, Alexandre Belloni wrote:
> Hi,
>
> This patch set fixes more issues with the clocks on AT91:
>
> The first patch define the slow crystal on the at91sam9261ek board
>
> The next patchs are moving all the clocks that were under the root under a
> "clocks" node to be consistent accross all architecture.

I'm just nitpicking here, but you could swap patch 1 and 2 so that
slow_xtal node appears directly under clocks node.

Apart from that,

Acked-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

>
> Alexandre Belloni (6):
>   ARM: at91/dt: define sam9261ek slow crystal frequency
>   ARM: at91/dt: sam9261 crystals under the clocks node
>   ARM: at91/dt: sam9n12 crystals under the clocks node
>   ARM: at91/dt: sam9rl crystals under the clocks node
>   ARM: at91/dt: sam9x5 crystals under the clocks node
>   ARM: at91/dt: sama5d3 crystals under the clocks node
>
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
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

