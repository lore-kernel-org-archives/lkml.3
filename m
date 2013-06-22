Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3FVPoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 11:44:22 -0400
Received: from smtp.newsguy.com ([74.209.136.69]:57279 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab3FVPoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 11:44:02 -0400
X-Greylist: delayed 1158 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Jun 2013 11:44:01 EDT
Message-ID: <51C5C23E.8070408@newsguy.com>
Date: Sat, 22 Jun 2013 08:26:54 -0700
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20130111 Thunderbird/10.0.11
MIME-Version: 1.0
To: Chao Xie <chao.xie@marvell.com>
CC: dmitry.torokhov@gmail.com, arnd@arndb.de, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, drwyrm@gmail.com, stefan@openezx.org,
        laforge@openezx.org, robert.jarzmik@free.fr, marek.vasut@gmail.com,
        sleep_walker@suse.cz, slapin@ossfans.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, xiechao.mail@gmail.com
Subject: Re: [PATCH V3 3/5] arm: pxa: use matrix_keymap for all boards
References: <1371527778-5236-1-git-send-email-chao.xie@marvell.com> <1371527778-5236-4-git-send-email-chao.xie@marvell.com>
In-Reply-To: <1371527778-5236-4-git-send-email-chao.xie@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 08:56 PM, Chao Xie wrote:
> Compile passed for configurations
> 
> em_x270_defconfig
>   em_x270x.c(MACH_EM_X270, MACH_EXEDA)
> 
> ezx_defconfig
>   ezx.c(MACH_EZX_A780, MACH_EZX_E680, MACH_EZX_A1200,
>         MACH_EZX_A910, MACH_EZX_E6, MACH_EZX_E2)
> 
> palmz72_defconfig
>   palmld.c(MACH_PALMLD), palmtreo.c(PALM_TREO),
>   palmtx.c(MACH_PALMTX), palmz72.c(MACH_PALMZ72),
>   palmt5.c(MACH_PALMT5)
> 
> pxa3xx_defconfig
>   littleton.c(MACH_LITTLETON), tarvorevb.c(MACH_TAVOREVB),
>   zylonite.c(MACH_ZYLONITE320), mioa701.c(MACH_MIOA701),
>   z2.c(MACH_ZIPIT2)
> 
> mainstone_defconfig
>   maintone.c(MACH_MAINSTONE)
> 
> Signed-off-by: Chao Xie <chao.xie@marvell.com>


Tested-by: Mike Dunn <mikedunn@newsguy.com>

On a palm treo 680

