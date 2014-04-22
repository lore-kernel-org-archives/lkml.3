Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaDVSkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:40:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57648 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaDVSkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:40:05 -0400
Message-ID: <5356B769.1020306@ti.com>
Date: Tue, 22 Apr 2014 14:39:37 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>, Nishanth Menon <nm@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: OMAP5: Switch to THUMB mode if needed on secondary
 CPU
References: <1398191506-3741-1-git-send-email-joelf@ti.com>
In-Reply-To: <1398191506-3741-1-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2014 02:31 PM, Joel Fernandes wrote:
> On my DRA7 system, when the kernel is built in THUMB mode, the secondary CPU
> (Cortex A15) fails to come up causing SMP boot on second CPU to timeout. This
> seems to be because the CPU is in ARM mode once the ROM hands over control to
> the kernel.  Switch to THUMB mode if required once the kernel is control of
> secondary CPU. On OMAP4 on the other hand, it appears to be in THUMB mode on
> entry so this is not required and SMP boot works as is.
> 
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Nishanth Menon <nm@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/mach-omap2/omap-headsmp.S |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
Looks fine to me ..
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


