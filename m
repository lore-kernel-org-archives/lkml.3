Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3HSWiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:38:55 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4264 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab3HSWiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:38:54 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <52129E7B.9060708@broadcom.com>
Date: Mon, 19 Aug 2013 15:38:51 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Christian Daudt" <csd@broadcom.com>
cc: "Russell King" <linux@arm.linux.org.uk>,
        "Stephen Warren" <swarren@nvidia.com>,
        "Olof Johansson" <olof@lixom.net>,
        "Markus Mayer" <markus.mayer@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: bcm: Rename board_bcm
References: <1375989863-17144-1-git-send-email-csd@broadcom.com>
In-Reply-To: <1375989863-17144-1-git-send-email-csd@broadcom.com>
X-WSS-ID: 7E0C421A31W85794265-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-08-08 12:24 PM, Christian Daudt wrote:
> In order to support multiple SoC models in the mach-bcm
> directory, board_bcm.c is being renamed board_bcm281xx.c
>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Signed-off-by: Christian Daudt <csd@broadcom.com>
>
> diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
> index 6adb6aec..873817e 100644
> --- a/arch/arm/mach-bcm/Makefile
> +++ b/arch/arm/mach-bcm/Makefile
> @@ -10,6 +10,6 @@
>   # of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   # GNU General Public License for more details.
>   
> -obj-$(CONFIG_ARCH_BCM)		:= board_bcm.o bcm_kona_smc.o bcm_kona_smc_asm.o
> +obj-$(CONFIG_ARCH_BCM)		:= board_bcm281xx.o bcm_kona_smc.o bcm_kona_smc_asm.o
>   plus_sec := $(call as-instr,.arch_extension sec,+sec)
>   AFLAGS_bcm_kona_smc_asm.o	:=-Wa,-march=armv7-a$(plus_sec)
> diff --git a/arch/arm/mach-bcm/board_bcm.c b/arch/arm/mach-bcm/board_bcm281xx.c
> similarity index 100%
> rename from arch/arm/mach-bcm/board_bcm.c
> rename to arch/arm/mach-bcm/board_bcm281xx.c
Applied to bcm/for-3.12/soc

  thanks,
    csd


