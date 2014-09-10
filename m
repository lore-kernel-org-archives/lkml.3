Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaIJIRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:17:55 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55159 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaIJIRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:17:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Robin Gong <b38343@freescale.com>, broonie@kernel.org, marex@denx.de,
        shawn.guo@linaro.org, Frank.Li@freescale.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH v5] spi: spi-imx: add DMA support
Date: Wed, 10 Sep 2014 10:17:14 +0200
Message-ID: <5412055.BAOgFikuh9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410312604-31949-1-git-send-email-b38343@freescale.com>
References: <1410312604-31949-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XXRhn3BKxd5Go5JUsjAaPtKdFKjvqDd+eNH7xJrvc6h
 Ce3oXj+Crj688JOiRwIaVRWRcAa4jXz4ymmJUTGGd/eQzULJNS
 YlOkLwUPywSQ2PiM3JOMO9Tq/JHajKhOsLvTpk31h/+7Clu30q
 O7ReFxHj/Tgtj9FBwBO3EMbuy27wUC3dZYqphmEQFrLMh3+clR
 rnGR+l6BIDMK/XZEgmOGeRCwaH/96a7xvEzXShQAqk1DnV0+Zn
 QLbfNDTFDzjcUo+gFdE/yGOW3WJtotOQ9CEImJl8C/KbCcy6V9
 J+s+El4IzHNTS15lpEAIOu3T4f0aIACsFoP6A81G06sS5eHkhD
 ZLqYqiyTtGemOl4F9IaI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2014 09:30:04 Robin Gong wrote:
> Enable DMA support on i.mx6. The read speed can increase from 600KB/s
> to 1.2MB/s on i.mx6q. You can disable or enable dma function in dts.
> If not set "dma-names" in dts, spi will use PIO mode. This patch only
> validate on i.mx6, not i.mx5, but encourage ones to apply this patch
> on i.mx5 since they share the same IP.
> 
> Note:
>   Sometime, there is a weid data in rxfifo after one full tx/rx
> transfer finish by DMA on i.mx6dl, so we disable dma functhion on
> i.mx6dl.
> 
> Signed-off-by: Frank Li <Frank.Li@freescale.com>
> Signed-off-by: Robin Gong <b38343@freescale.com>
> 
> 

The patch looks good to me, but you need to also update the
Documentation/devicetree/bindings/spi/fsl-imx-cspi.txt file to
document the additional optional properties.

	Arnd
