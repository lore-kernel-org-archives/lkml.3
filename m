Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab3KOBp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 20:45:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab3KOBps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 20:45:48 -0500
Date: Fri, 15 Nov 2013 10:32:48 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux-fbdev@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] video: exynos_mipi_dsim: Remove unused variable
Message-ID: <20131115013248.GA6541@kroah.com>
References: <1384463364-28864-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384463364-28864-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 01:09:24PM -0800, Olof Johansson wrote:
> commit 7e0be9f9f7cba3356f75b86737dbe3a005da067e ('video: exynos_mipi_dsim:
> Use the generic PHY driver') resulted in a warning about an unused
> variable:
> 
> drivers/video/exynos/exynos_mipi_dsi.c:144:26: warning: unused variable
>     'pdev' [-Wunused-variable]
> 
> It is indeed unused; remove it.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/video/exynos/exynos_mipi_dsi.c |    1 -
>  1 file changed, 1 deletion(-)

I had to take the offending patch through my tree due to the phy
changes, but I'm not the maintainer of it, nor the video mantainer, so I
can't really take this patch through my trees, sorry.

greg k-h
