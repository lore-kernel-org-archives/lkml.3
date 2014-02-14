Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaBNJ1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:27:05 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:41887 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaBNJ1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:27:01 -0500
Date: Fri, 14 Feb 2014 09:26:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Semen Protsenko <semen.protsenko@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH] mfd: vexpress-sysreg: initialize "site" variable
Message-ID: <20140214092656.GH3403@lee--X1>
References: <1392309594-28229-1-git-send-email-semen.protsenko@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392309594-28229-1-git-send-email-semen.protsenko@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "site" variable should be initialized with 0 so that
> when "site" property doesn't exist in DTB it can be handled correctly.
> 
> "0" value means board site number is motherboard (see
> Documentation/devicetree/bindings/arm/vexpress.txt for details).
> 
> Signed-off-by: Semen Protsenko <semen.protsenko@linaro.org>
> ---
>  drivers/mfd/vexpress-sysreg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
