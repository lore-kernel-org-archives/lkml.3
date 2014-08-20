Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaHTGPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:15:39 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:36684 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaHTGPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:15:37 -0400
Date: Wed, 20 Aug 2014 08:15:27 +0200
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
Subject: Re: [PATCH v1 03/12] dmaengine: dw: convert dw_dma_slave to use
 explicit HS interfaces
Message-ID: <20140820061526.GB20366@samfundet.no>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408469363-15901-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408469363-15901-4-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 19 Aug 2014 20:29:14 +0300 or thereabout, Andy Shevchenko wrote:
> Instead of exposing the possibility to set DMA registers CFG_HI and CFG_LO
> strict user to provide handshake interfaces explicitly.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/mach-at32ap/at32ap700x.c  | 15 +++++----------
>  drivers/dma/dw/core.c                |  4 ++--
>  include/linux/platform_data/dma-dw.h | 10 ++++------
>  3 files changed, 11 insertions(+), 18 deletions(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
