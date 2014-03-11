Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaCKQIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:08:45 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49203 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaCKQIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:08:43 -0400
Date: Tue, 11 Mar 2014 16:08:37 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/5] mfd: add bcm590xx pmu driver
Message-ID: <20140311160837.GP21216@lee--X1>
References: <1394552775-31264-1-git-send-email-mporter@linaro.org>
 <1394552775-31264-3-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394552775-31264-3-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add a driver for the BCM590xx PMU multi-function devices. The driver
> initially supports regmap initialization and instantiation of the
> voltage regulator device function of the PMU.
> 
> Signed-off-by: Matt Porter <mporter@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  drivers/mfd/Kconfig          |  8 ++++
>  drivers/mfd/Makefile         |  1 +
>  drivers/mfd/bcm590xx.c       | 93 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/bcm590xx.h | 31 +++++++++++++++
>  4 files changed, 133 insertions(+)
>  create mode 100644 drivers/mfd/bcm590xx.c
>  create mode 100644 include/linux/mfd/bcm590xx.h

I have a tiny nit that 'ret' doesn't need to be initialised before
use in probe(), but apart from that...

Looks pretty sensible:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
