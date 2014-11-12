Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaKLJeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:34:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54617 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbaKLJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:34:07 -0500
Date: Wed, 12 Nov 2014 09:34:04 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, broonie@kernel.org, linus.walleij@linaro.org,
        gnurou@gmail.com, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3] mfd: arizona: Add support for CS47L24
Message-ID: <20141112093404.GC23178@opensource.wolfsonmicro.com>
References: <20141111165227.GA24344@opensource.wolfsonmicro.com> <20141111170319.GA25738@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111170319.GA25738@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 05:03:19PM +0000, Richard Fitzgerald wrote:
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/Kconfig              |    6 +
>  drivers/mfd/Makefile             |    3 +
>  drivers/mfd/arizona-core.c       |   91 ++-
>  drivers/mfd/arizona-irq.c        |   42 +-
>  drivers/mfd/arizona-spi.c        |    9 +
>  drivers/mfd/arizona.h            |    5 +
>  drivers/mfd/cs47l24-tables.c     | 1632 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/arizona/core.h |    4 +
>  8 files changed, 1765 insertions(+), 27 deletions(-)
>  create mode 100644 drivers/mfd/cs47l24-tables.c

Its worth noting this patch chain depends on the three MFD
patches Lee merged the other day from me so it would probably
make sense to push the whole series through the MFD tree if
possible.

Thanks,
Charles
