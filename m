Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaAFTeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:34:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34849 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbaAFTeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:34:19 -0500
Message-ID: <52CB051B.1040808@ti.com>
Date: Mon, 6 Jan 2014 14:33:47 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Regression (ARM) arch/arm/mm/init.c doesn't build without CONFIG_ARM_PATCH_PHYS_VIRT.
References: <m38uv1uuzr.fsf@t19.piap.pl> <m3ha9gx63v.fsf@t19.piap.pl>
In-Reply-To: <m3ha9gx63v.fsf@t19.piap.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 January 2014 02:28 PM, Krzysztof Hałasa wrote:
> Russell, Santosh,
> 
> the unneeded commit causing regression is still in place. Please try to
> compile an ARM kernel without CONFIG_ARM_PATCH_PHYS_VIRT and with
> CONFIG_ZONE_DMA and see for yourself, if you don't believe me.
> 
> Please be aware that this commit fixes nothing, its only function is
> causing the regression - so we don't lose anything by reverting it.
> 
I am afraid you didn't understood what the fix is if you say above.
arm_dma_limit is broken without this fix for LPAE machines with
memory starting 4 GB physical boundary.

Regards,
Santosh
