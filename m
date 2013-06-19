Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab3FSIfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:35:25 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:57803 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011Ab3FSIfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:35:22 -0400
Date: Wed, 19 Jun 2013 09:35:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        sameo@linux.intel.com, lgirdwood@gmail.com, broonie@kernel.org,
        balbi@ti.com, peter.ujfalusi@ti.com, t-kristo@ti.com, tony@atomide.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [RFC v1] MFD: Change TWL6025 references to TWL6032
Message-ID: <20130619083515.GC22998@laptop>
References: <1370602390-12306-1-git-send-email-oleksandr.kozaruk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1370602390-12306-1-git-send-email-oleksandr.kozaruk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Jun 2013, Oleksandr Kozaruk wrote:

> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> The TWL6025 was never released beyond sample form and was replaced by
> the PhoenixLite range of chips - TWL6032. Change the references to
> reference the TWL6032 class and name the registers to twl6032 in line with
> an actual released chip name to avoid confusion.
> 
> Currently there is no users of TWL6025 in the code. 
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
> ---
> 
> There are non-mainline branches that use twl6032 by its name (for example
> git://git.omapzoom.org/kernel/omap.git). There is intention to add support
> of twl6032 device in mainline, but we'd like to know if we can use twl6032
> instead of twl6025 in our new patches, that we are going to provide.
> 
>  drivers/mfd/twl-core.c            |   46 +++++++++++-----------
>  drivers/regulator/twl-regulator.c |   76 ++++++++++++++++++-------------------
>  drivers/usb/phy/phy-twl6030-usb.c |    2 +-
>  include/linux/i2c/twl.h           |   30 +++++++--------
>  4 files changed, 77 insertions(+), 77 deletions(-)

If the TWL6025 truly didn't enter production then I'm okay with this
as long as Mark and the other maintainers are.

For the MFD parts:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
