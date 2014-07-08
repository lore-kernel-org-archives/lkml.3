Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaGHBkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:40:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaGHBkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 21:40:19 -0400
Date: Mon, 7 Jul 2014 18:44:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] phy: phy-samsung-usb2: Change phy power on/power off
 sequence
Message-ID: <20140708014442.GB13844@kroah.com>
References: <1404715705-5041-1-git-send-email-kishon@ti.com>
 <1404715705-5041-4-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404715705-5041-4-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 12:18:20PM +0530, Kishon Vijay Abraham I wrote:
> From: Kamil Debski <k.debski@samsung.com>
> 
> The Exynos4412 USB 2.0 PHY hardware differs from the description provided
> in the documentation. Some register bits have different function. This
> patch fixes the defines of register bits and changes the way how phys are
> powered on and off.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Daniel Drake <drake@endlessm.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/phy-exynos4x12-usb2.c |  112 +++++++++++++++++++++++++------------
>  drivers/phy/phy-exynos5250-usb2.c |    2 -
>  drivers/phy/phy-samsung-usb2.h    |    3 +-
>  3 files changed, 77 insertions(+), 40 deletions(-)
> 

This doesn't look like a regression fix for 3.16-final, it looks like a
"new feature" to me :(

sorry, I can't take this pull request, want me to pick the individual
patches instead?


thanks,

greg k-h
