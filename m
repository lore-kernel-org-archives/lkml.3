Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaD1L4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:56:35 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39781 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaD1L4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:56:33 -0400
Date: Mon, 28 Apr 2014 12:56:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/4] mfd: bcm590xx: add support for secondary I2C
 slave address
Message-ID: <20140428115627.GY21279@lee--X1>
References: <1398295293-11033-1-git-send-email-mporter@linaro.org>
 <1398295293-11033-3-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398295293-11033-3-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Matt Porter wrote:

> BCM590xx utilizes a secondary I2C slave address to access additional
> register space. Add support for the secondary address space by
> instantiating a dummy I2C device with the appropriate secondary
> I2C slave address. Also expose a secondary regmap register space so
> that MFD drivers can access this secondary i2c slave address space.
> 
> Signed-off-by: Matt Porter <mporter@linaro.org>
> ---
>  drivers/mfd/bcm590xx.c       | 60 +++++++++++++++++++++++++++++++++-----------
>  include/linux/mfd/bcm590xx.h |  9 ++++---
>  2 files changed, 52 insertions(+), 17 deletions(-)

Nice, flows much better now.

Can I just apply the two MFD patches, or are there cross-deps?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
