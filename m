Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaEDAyB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 20:54:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaEDAx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 20:53:59 -0400
Date: Sat, 3 May 2014 19:17:54 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-doc@vger.kernel.org, t.figa@samsung.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        robh+dt@kernel.org, arnd@arndb.de, grant.likely@linaro.org,
        kgene.kim@samsung.com, rdunlap@infradead.org, ben-linux@fluff.org
Subject: Re: [PATCH 1/2] misc: add sii9234 driver
Message-ID: <20140503231754.GB20212@kroah.com>
References: <1397216910-15904-1-git-send-email-t.stanislaws@samsung.com>
 <1397216910-15904-2-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397216910-15904-2-git-send-email-t.stanislaws@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 01:48:29PM +0200, Tomasz Stanislawski wrote:
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 1cb7408..3b7f266 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -515,6 +515,14 @@ config SRAM
>  	  the genalloc API. It is supposed to be used for small on-chip SRAM
>  	  areas found on many SoCs.
>  
> +config SII9234
> +	tristate "Silicon Image SII9234 Driver"
> +	depends on I2C

I doubt this is the only dependency, right?

thanks,

greg k-h
