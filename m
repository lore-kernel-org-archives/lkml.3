Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3KYWMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:12:39 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47452 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750709Ab3KYWMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:12:38 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+GWVqcT5XRoOtmXT/MrkiE
Date: Mon, 25 Nov 2013 14:12:32 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] AES/DES hwmod data and dmtimer fix
Message-ID: <20131125221232.GV10023@atomide.com>
References: <1385415876-12387-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385415876-12387-1-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [131125 13:46]:
> Here are patches adding hwmod for AES/DES crypto modules for OMAP4, DRA7 SoCs.
> 
> Also included is a fix that disables POSTED mode when dmtimer is requested.
> 
> Joel Fernandes (7):
>   ARM: OMAP: hwmod: Add SYSC offsets for AES IP
>   ARM: DRA7xx: hwmod: Add hwmod data for DES IP
>   ARM: DRA7xx: hwmod: Add hwmod data for AES IP
>   ARM: OMAP4: hwmod: Add hwmod data for AES IP
>   ARM: OMAP4: hwmod: add hwmod data for DES IP
>   ARM: OMAP: Disable POSTED mode for errata i103 and i767
>   OMAP: AM33xx: hwmod: Correct AES module SYSC type
> 
>  arch/arm/mach-omap2/omap_hwmod.h                   |  11 +++
>  .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |   1 +
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c         | 101 +++++++++++++++++++++
>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  78 ++++++++++++++++
>  arch/arm/mach-omap2/omap_hwmod_common_data.c       |  10 ++
>  arch/arm/plat-omap/include/plat/dmtimer.h          |   5 +-
>  6 files changed, 205 insertions(+), 1 deletion(-)

To me it seems we should wait on these until we have the clocks
coming from device tree. That leaves out some parts of this
patchset.

Regards,

Tony
