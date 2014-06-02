Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaFBQAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:00:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60580 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaFBQAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:00:08 -0400
Message-ID: <538C9F83.1010800@wwwdotorg.org>
Date: Mon, 02 Jun 2014 10:00:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>
CC: thierry.reding@gmail.com, arm@kernel.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch
Subject: Re: [PATCH 1/3] arm: multi_v7: enable igb, stmpe, spidev, lm95245,
 pwm leds
References: <cc612cd3f24f01cfc8fd3e81b1027ff94862e8b4.1401700579.git.marcel@ziswiler.com>
In-Reply-To: <cc612cd3f24f01cfc8fd3e81b1027ff94862e8b4.1401700579.git.marcel@ziswiler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 03:43 AM, Marcel Ziswiler wrote:
> The NVIDIA Tegra 3 based Apalis T30 module contains an Intel i210 resp.
> i211 gigabit Ethernet controller, an STMPE811 ADC/touch controller,
> SPI bus and PWM LEDs generically accessible from user space and an
> LM95245 temperature sensor chip. The later four can also be found on
> the Colibri T30 module.
> 
> While at it move the NEON entry down to its proper place to have it all
> nicely ordered again.
> 
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
> ---
> BTW: How about TEGRA_EMC_SCALING_ENABLE

I thought a patch was sent to remove that. Perhaps the patch was only
sent to tegra_defconfig.

> ... MTD_M25P80 which depends on MTD_SPI_NOR

I've seen patches to fix that too.
