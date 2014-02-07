Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaBGLM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:12:57 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39728 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBGLMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:12:37 -0500
Date: Fri, 7 Feb 2014 11:12:29 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        sameo@linux.intel.com, grant.likely@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 2/4] MFD: TPS65218: Add driver for the TPS65218 PMIC
Message-ID: <20140207111229.GN14727@lee--X1>
References: <1391665814-18814-1-git-send-email-j-keerthy@ti.com>
 <1391665814-18814-3-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391665814-18814-3-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Feb 2014, Keerthy wrote:

> The TPS65218 chip is a power management IC for Portable Navigation Systems
> and Tablet Computing devices. It contains the following components:
> 
>  - Regulators.
>  - Over Temperature warning and Shut down.
> 
> This patch adds support for tps65218 mfd device. At this time only
> the regulator functionality is made available.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  drivers/mfd/Kconfig          |   15 +++
>  drivers/mfd/Makefile         |    1 +
>  drivers/mfd/tps65218.c       |  281 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/tps65218.h |  284 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 581 insertions(+)
>  create mode 100644 drivers/mfd/tps65218.c
>  create mode 100644 include/linux/mfd/tps65218.h

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
