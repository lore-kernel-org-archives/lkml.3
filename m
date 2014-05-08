Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaEHIA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:00:58 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36166 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbaEHIA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:00:57 -0400
Date: Thu, 8 May 2014 09:00:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
Subject: Re: [RESEND] [PATCH V1 1/2] mfd: da9063: Upgrade of register
 definitions to support production silicon
Message-ID: <20140508080050.GD5307@lee--X1>
References: <cover.1399465372.git.stwiss.opensource@diasemi.com>
 <231daa66bd20fabc7b3b58ea4e841767969bbefc.1399465372.git.stwiss.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <231daa66bd20fabc7b3b58ea4e841767969bbefc.1399465372.git.stwiss.opensource@diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> 
> This patch updates the register definitions for DA9063 to support the
> production silicon variant code ID (0x5). These changes are not backwards
> compatible with the previous register definitions and can only be used
> with the production variant of DA9063.
> 
> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> ---
> Checks performed with next-20140306/scripts/checkpatch.pl
>  registers.h               total: 0 errors, 0 warnings, 1032 lines checked
> 
> This is a resend of the original patch set, now adding Andrew Morton after
> the RTC driver PATCH-0002 has been waiting to be merged since March.
> 
> PLEASE NOTE: Lee Jones has already applied this registers.h patch into
> the linux-next tree. See here: https://lkml.org/lkml/2014/3/10/267

Actually, this patch is now in Mainline.  You can drop it from the set.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
