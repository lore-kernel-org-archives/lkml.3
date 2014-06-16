Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbaFPS5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:57:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42984 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaFPS5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:57:53 -0400
Message-ID: <539F3E2E.8060602@wwwdotorg.org>
Date: Mon, 16 Jun 2014 12:57:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH v2 2/3] arm: tegra: enable igb, stmpe, i2c chardev, lm95245,
 pwm leds
References: <dadd07f9ed693d6bcf541764b62a2caf4cc38630.1402353627.git.marcel@ziswiler.com>
In-Reply-To: <dadd07f9ed693d6bcf541764b62a2caf4cc38630.1402353627.git.marcel@ziswiler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 04:52 PM, Marcel Ziswiler wrote:
> The NVIDIA Tegra 3 based Apalis T30 module contains an Intel i210 resp.
> i211 gigabit Ethernet controller, an STMPE811 ADC/touch controller, I2C
> buses and PWM LEDs generically accessible from user space and an
> LM95245 temperature sensor chip. The later four can also be found on
> the Colibri T30 module.

I've applied this patch to Tegra's for-3.17/defconfig branch.
