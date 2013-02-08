Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946550Ab3BHPGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:06:55 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:49558 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946372Ab3BHPGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:06:54 -0500
Date: Fri, 8 Feb 2013 15:06:53 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Philip Avinash <avinashphilip@ti.com>
cc: tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com
Subject: Re: [PATCH 4/7] ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK
In-Reply-To: <1357133094-30806-5-git-send-email-avinashphilip@ti.com>
Message-ID: <alpine.DEB.2.00.1302081505350.28008@utopia.booyaka.com>
References: <1357133094-30806-1-git-send-email-avinashphilip@ti.com> <1357133094-30806-5-git-send-email-avinashphilip@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2 Jan 2013, Philip Avinash wrote:

> EHRPWM module requires explicit clock gating of TBCLK from control
> module. Hence add TBCLK clock node in clock tree for EHRPWM modules.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

This patch adds some sparse[1] warnings:

> arch/arm/mach-omap2/cclock33xx_data.c:844:1: warning: Using plain 
integer as NULL pointer
> arch/arm/mach-omap2/cclock33xx_data.c:850:1: warning: Using plain 
integer as NULL pointer
> arch/arm/mach-omap2/cclock33xx_data.c:856:1: warning: Using plain 
integer as NULL pointer

Could you fix these, please?


- Paul

1. Sparse: https://sparse.wiki.kernel.org/index.php/Main_Page

