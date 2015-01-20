Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbbATKlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:41:55 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56384 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbbATKlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:41:52 -0500
Date: Tue, 20 Jan 2015 10:41:45 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: David Dajun Chen <david.chen@diasemi.com>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Support Opensource <support.opensource@diasemi.com>,
        DT <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/2]  Add device tree support for DA9063
Message-ID: <20150120104145.GQ5767@x1>
References: <cover.1421684991.git.stwiss.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1421684991.git.stwiss.opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Opensource [Steve Twiss] wrote:

> From: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> This patch set adds device tree support for the Dialog
> Semiconductor DA9063 PMIC. Support is provided for the
> Regulators; Real-Time Clock and Watchdog.
> 
> [PATCH V2 1/2]: kernel driver device tree support
> [PATCH V2 2/2]: device tree bindings document

As this is v2, I would expect to see a changelog somewhere.

> Thank you,
> Steve Twiss, Dialog Semiconductor Ltd.
> 
> S Twiss (2):
>   mfd: da9063: Add device tree support
>   devicetree: Add bindings for DA9063
> 
>  Documentation/devicetree/bindings/mfd/da9063.txt | 94 ++++++++++++++++++++++++
>  drivers/mfd/da9063-core.c                        |  2 +
>  drivers/mfd/da9063-i2c.c                         | 11 +++
>  include/linux/mfd/da9063/core.h                  |  1 +
>  4 files changed, 108 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/da9063.txt
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
