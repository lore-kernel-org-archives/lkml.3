Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaGUNVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:21:23 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:39114 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaGUNVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:21:22 -0400
Date: Mon, 21 Jul 2014 14:21:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Allow case labels with ranges
Message-ID: <20140721132116.GZ30888@lee--X1>
References: <20140721113948.GX30888@lee--X1>
 <1405948406.21586.10.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405948406.21586.10.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Joe Perches wrote:

> The MISSING_BREAK / fallthrough test does not support
> gcc's extension for case labels with ranges.
> 
> Add it.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Reported-by: Lee Jones <lee.jones@linaro.org>
> ---
>  scripts/checkpatch.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

[...]

Yep, that's much worse [1] - I wish I never mentioned it. ;)
 
Acked-by: Lee Jones <lee.jones@linaro.org>

[1]

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#330: FILE: drivers/mfd/tps80031.c:330:
+	case TPS80031_SMPS4_CFG_TRANS ... TPS80031_SMPS3_CFG_VOLTAGE:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#331: FILE: drivers/mfd/tps80031.c:331:
+	case TPS80031_BROADCAST_ADDR_ALL ... TPS80031_BROADCAST_ADDR_CLK_RST:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#332: FILE: drivers/mfd/tps80031.c:332:
+	case TPS80031_VANA_CFG_TRANS ... TPS80031_LDO7_CFG_VOLTAGE:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#333: FILE: drivers/mfd/tps80031.c:333:
+	case TPS80031_REGEN1_CFG_TRANS ... TPS80031_TMP_CFG_STATE:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#334: FILE: drivers/mfd/tps80031.c:334:
+	case TPS80031_PREQ1_RES_ASS_A ... TPS80031_PREQ3_RES_ASS_C:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#335: FILE: drivers/mfd/tps80031.c:335:
+	case TPS80031_SMPS_OFFSET ... TPS80031_BATDEBOUNCING:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#336: FILE: drivers/mfd/tps80031.c:336:
+	case TPS80031_CFG_INPUT_PUPD1 ... TPS80031_CFG_SMPS_PD:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#351: FILE: drivers/mfd/tps80031.c:351:
+	case TPS80031_PREQ1_RES_ASS_A ... TPS80031_PREQ3_RES_ASS_C:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#352: FILE: drivers/mfd/tps80031.c:352:
+	case TPS80031_SMPS_OFFSET ... TPS80031_BATDEBOUNCING:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#353: FILE: drivers/mfd/tps80031.c:353:
+	case TPS80031_CFG_INPUT_PUPD1 ... TPS80031_CFG_SMPS_PD:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#366: FILE: drivers/mfd/tps80031.c:366:
+	case TPS80031_TOGGLE1 ... TPS80031_VIBMODE:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#367: FILE: drivers/mfd/tps80031.c:367:
+	case TPS80031_PWM1ON ... TPS80031_PWM2OFF:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#368: FILE: drivers/mfd/tps80031.c:368:
+	case TPS80031_FG_REG_00 ... TPS80031_FG_REG_11:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#369: FILE: drivers/mfd/tps80031.c:369:
+	case TPS80031_INT_STS_A ... TPS80031_INT_MSK_STS_C:

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#370: FILE: drivers/mfd/tps80031.c:370:
+	case TPS80031_CONTROLLER_CTRL2 ... TPS80031_LED_PWM_CTRL2:

total: 0 errors, 15 warnings, 574 lines checked

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
