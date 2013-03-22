Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422696Ab3CVRYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:24:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42299 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422684Ab3CVRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:23:58 -0400
Date: Fri, 22 Mar 2013 17:23:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de
Subject: Re: [PATCH 1/5] ARM: ux500: Add machine support for ccu8540
Message-ID: <20130322172346.GG4977@n2100.arm.linux.org.uk>
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 03:27:41PM +0000, Lee Jones wrote:
> diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
> index 831e1fd..1c9d0be 100644
> --- a/arch/arm/tools/mach-types
> +++ b/arch/arm/tools/mach-types
> @@ -1204,3 +1204,4 @@ baileys			MACH_BAILEYS		BAILEYS			4169
>  familybox		MACH_FAMILYBOX		FAMILYBOX		4170
>  ensemble_mx35		MACH_ENSEMBLE_MX35	ENSEMBLE_MX35		4171
>  sc_sps_1		MACH_SC_SPS_1		SC_SPS_1		4172
> +u8540			MACH_U8540		U8540			4211

If you need this updated, please ask. :)
