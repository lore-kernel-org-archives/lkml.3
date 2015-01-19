Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbbASJ45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:56:57 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:55627 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbASJ4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:56:55 -0500
Date: Mon, 19 Jan 2015 09:56:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, DT <devicetree@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Support Opensource <support.opensource@diasemi.com>
Subject: Re: [PATCH V1] mfd: da9063: Add device tree support
Message-ID: <20150119095649.GO21886@x1>
References: <201501141438.t0EEcMBg010491@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201501141438.t0EEcMBg010491@swsrvapps-01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Steve Twiss wrote:

> From: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> Add device tree support for DA9063 regulators; Real-Time Clock
> and Watchdog.
> 
> 
> Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> ---
> Checks performed with linux-next/v3.19-rc4/scripts/checkpatch.pl
>  da9063.txt                total: 0 errors, 0 warnings, 94 lines checked
>  da9063-core.c             total: 0 errors, 0 warnings, 192 lines checked
>  da9063-i2c.c              total: 0 errors, 0 warnings, 277 lines checked
>  core.h                    total: 0 errors, 0 warnings, 99 lines checked
> This patch applies against linux-next and v3.19-rc4 
> 
> 
> 
>  Documentation/devicetree/bindings/mfd/da9063.txt | 94 ++++++++++++++++++++++++

Ah, and this should be in a separate patch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
