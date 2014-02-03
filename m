Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaBCKfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:35:33 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43623 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaBCKf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:35:28 -0500
Date: Mon, 3 Feb 2014 10:35:22 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: sec-core: sec_pmic_{suspend,resume}() should
 depend on CONFIG_PM_SLEEP
Message-ID: <20140203103522.GR13529@lee--X1>
References: <1390732723-7129-1-git-send-email-geert@linux-m68k.org>
 <1390732723-7129-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390732723-7129-2-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If CONFIG_PM_SLEEP=n:
> 
> drivers/mfd/sec-core.c:349: warning: ‘sec_pmic_suspend’ defined but not used
> drivers/mfd/sec-core.c:371: warning: ‘sec_pmic_resume’ defined but not used
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/mfd/sec-core.c |    2 ++
>  1 file changed, 2 insertions(+)

Applied to my -fixes branch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
