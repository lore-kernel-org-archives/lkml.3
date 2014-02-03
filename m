Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaBCKe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:34:59 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42949 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaBCKe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:34:57 -0500
Date: Mon, 3 Feb 2014 10:34:48 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: max14577: max14577_{suspend,resume}() should
 depend on CONFIG_PM_SLEEP
Message-ID: <20140203103448.GQ13529@lee--X1>
References: <1390732723-7129-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390732723-7129-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If CONFIG_PM_SLEEP=n:
> 
> drivers/mfd/max14577.c:177: warning: ‘max14577_suspend’ defined but not used
> drivers/mfd/max14577.c:200: warning: ‘max14577_resume’ defined but not used
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/mfd/max14577.c |    2 ++
>  1 file changed, 2 insertions(+)

Applied to my -fixes branch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
