Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbaD3OHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:07:31 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:49657 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaD3OHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:07:30 -0400
Date: Wed, 30 Apr 2014 15:07:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH] mfd: syscon: allow property as NULL in
 syscon_regmap_lookup_by_phandle
Message-ID: <20140430140718.GQ29462@lee--X1>
References: <1398824066-3036-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398824066-3036-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we pass syscon device node itself as first parameter to this function
> there is no need to parse and find syscon device node. So by allowing
> "property" parameter as NULL allow syscon_regmap_lookup_by_phandle to
> consider passed argument "np" itself as a syscon device node "syscon_np".
> This will help us in avoiding addition of "syscon" property in a device node
> which points back to same device node in device tree.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  drivers/mfd/syscon.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Seems reasonable.  Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
