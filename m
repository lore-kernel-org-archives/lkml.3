Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaHTGC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:02:26 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:47538 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaHTGCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:02:24 -0400
Date: Wed, 20 Aug 2014 08:01:30 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 01/12] dmaengine: dw: move dw_dmac.h to where it
 belongs to
Message-ID: <20140820060130.GA17757@samfundet.no>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408469363-15901-2-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408469363-15901-2-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 19 Aug 2014 20:29:12 +0300 or thereabout, Andy Shevchenko wrote:
> There is a common storage for platform data related structures and definitions
> inside kernel source tree. The patch moves file from include/linux to
> include/linux/platform_data and renames it acoordingly. The users are also
> updated.

Nice cleanup, thanks.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>

For the arch/avr32/.* and .*sound/atmel.* related changes
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  MAINTAINERS                                     |   2 +-
>  arch/avr32/mach-at32ap/at32ap700x.c             |   2 +-
>  arch/avr32/mach-at32ap/include/mach/atmel-mci.h |   2 +-
>  drivers/dma/dw/internal.h                       |   2 +-
>  drivers/dma/dw/regs.h                           |   6 +-
>  include/linux/dw_dmac.h                         | 111 ------------------------
>  include/linux/platform_data/dma-dw.h            | 111 ++++++++++++++++++++++++
>  include/sound/atmel-abdac.h                     |   2 +-
>  include/sound/atmel-ac97c.h                     |   2 +-
>  sound/atmel/abdac.c                             |   2 +-
>  sound/atmel/ac97c.c                             |   2 +-
>  11 files changed, 122 insertions(+), 122 deletions(-)
>  delete mode 100644 include/linux/dw_dmac.h
>  create mode 100644 include/linux/platform_data/dma-dw.h

<snipp diff>

-- 
BR, HcE
