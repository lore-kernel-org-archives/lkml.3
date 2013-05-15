Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab3EOMeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:34:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39493 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567Ab3EOMeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:34:20 -0400
Message-ID: <51938169.4060109@ti.com>
Date: Wed, 15 May 2013 18:06:57 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?VmluY2VudCBTdGVobMOp?= <vincent.stehle@laposte.net>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VmluY2VudCBTdGVobMOp?= <v-stehle@ti.com>
Subject: Re: [PATCH] ARM: OMAP5: select SCU
References: <1368550638-2046-1-git-send-email-vincent.stehle@laposte.net>
In-Reply-To: <1368550638-2046-1-git-send-email-vincent.stehle@laposte.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 May 2013 10:27 PM, Vincent Stehlé wrote:
> From: Vincent Stehlé <v-stehle@ti.com>
> 
> OMAP5 needs SCU in SMP.
> 
> This fixes the following link errors:
> 
>   arch/arm/mach-omap2/built-in.o: In function `scu_gp_set':
>   arch/arm/mach-omap2/sleep44xx.S:132: undefined reference to `scu_power_mode'
>   arch/arm/mach-omap2/built-in.o: In function `scu_gp_clear':
>   arch/arm/mach-omap2/sleep44xx.S:229: undefined reference to `scu_power_mode'
>   arch/arm/mach-omap2/built-in.o: In function `omap4_smp_prepare_cpus':
>   arch/arm/mach-omap2/omap-smp.c:211: undefined reference to `scu_enable'
>   arch/arm/mach-omap2/built-in.o: In function `omap4_smp_init_cpus':
>   arch/arm/mach-omap2/omap-smp.c:185: undefined reference to `scu_get_core_count'
> 
> Signed-off-by: Vincent Stehlé <v-stehle@ti.com>
> ---
OMAP5 doesn't need the SCU. So Nak for the patch. I haven't noticed
this earlier. Do you know which commit broke this ?

Regards,
Santosh

