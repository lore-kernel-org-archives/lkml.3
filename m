Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbaESR2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:28:25 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37031 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450AbaESR2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:28:23 -0400
Date: Mon, 19 May 2014 18:28:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org, Carlo Caione <carlo@caione.org>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 1/3] mfd: AXP22x: add support for APX221 PMIC
Message-ID: <20140519172817.GE20435@lee--X1>
References: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
 <1400176305-22737-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400176305-22737-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch introduces preliminary support for the X-Powers AXP221 PMIC.
> The AXP221 is typically used on boards using Allwinner's A31 SoC.
> 
> At the moment, this driver only exposes regulator devices, but other
> subdevices.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/mfd/Kconfig        |  12 +++
>  drivers/mfd/Makefile       |   1 +
>  drivers/mfd/axp22x.c       | 237 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/axp22x.h | 149 ++++++++++++++++++++++++++++
>  4 files changed, 399 insertions(+)
>  create mode 100644 drivers/mfd/axp22x.c
>  create mode 100644 include/linux/mfd/axp22x.h

Not a chance.

Farrrr, too much common code with axp20x.c - please merge into one file.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
