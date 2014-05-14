Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaENThE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:37:04 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61384 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaENThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:37:01 -0400
Message-ID: <5373C5CF.4040002@gmail.com>
Date: Wed, 14 May 2014 21:36:47 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com
CC: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, chanho61.park@samsung.com,
        sajjan.linux@gmail.com, tushar.behera@linaro.org,
        sachin.kamat@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCHv5 5/5] ARM: dts: Add device tree sources for Exynos3250
References: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com> <1399986308-23744-6-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1399986308-23744-6-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13.05.2014 15:05, Chanwoo Choi wrote:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> This patch add new exynos3250.dtsi to support Exynos3250 SoC based on Cortex-A7
> dual core and includes following dt nodes:
> 
> - GIC interrupt controller
> - Pinctrl to control GPIOs
> - Clock controller
> - CPU information (Cortex-A7 dual core)
> - UART to support serial port
> - MCT (Multi Core Timer)
> - ADC (Analog Digital Converter)
> - I2C/SPI bus
> - Power domain
> - PMU (Performance Monitoring Unit)
> - MSHC (Mobile Storage Host Controller)
> - PWM (Pluse Width Modulation)
> - AMBA bus
> - sysram node for SYSRAM memory mapping

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
