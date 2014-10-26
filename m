Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaJZOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 10:09:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaJZOJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 10:09:56 -0400
Message-ID: <544D00B1.7070703@suse.de>
Date: Sun, 26 Oct 2014 15:09:53 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: suravee.suthikulpanit@amd.com
CC: mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>, marc.zyngier@arm.com,
        liviu.dudau@arm.com, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 24.10.2014 um 14:20 schrieb suravee.suthikulpanit@amd.com:
> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
> index f8001a6..6c27047 100644
> --- a/arch/arm64/boot/dts/Makefile
> +++ b/arch/arm64/boot/dts/Makefile
> @@ -1,6 +1,7 @@
>  dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
> +dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb

It seems these lines are sorted alphabetically, so Seattle should go
somewhere before Thunder.

>  
>  targets += dtbs
>  targets += $(dtb-y)

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
