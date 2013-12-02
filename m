Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3LBNNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:13:37 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:53530 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3LBNNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:13:35 -0500
Date: Mon, 2 Dec 2013 13:13:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ruslan Ruslichenko <ruslan.ruslichenko@globallogic.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: twl-core: Clean up module by removing twl603x pdata
 handling
Message-ID: <20131202131331.GE31626@lee--X1>
References: <1385036008-1727-1-git-send-email-ruslan.ruslichenko@globallogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385036008-1727-1-git-send-email-ruslan.ruslichenko@globallogic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013, Ruslan Ruslichenko wrote:

> Since currently nobody uses TWL603x platform data and all new
> users will supply it through device tree, handling of these
> data within twl-core will never be used, so remove it.
> 
> Signed-off-by: Ruslan Ruslichenko <ruslan.ruslichenko@globallogic.com>
> ---
> 
> Tested on TI SDP/Tablet OMAP4460 board
> Based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> commit 5e01dc7 Linux 3.12
> 
>  drivers/mfd/twl-core.c | 198 -------------------------------------------------
>  1 file changed, 198 deletions(-)

Okay, I'm suitably happy with yours and Tony's responses.

Patch applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
