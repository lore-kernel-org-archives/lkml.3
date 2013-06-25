Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3FYJZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:25:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:32221 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab3FYJZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,935,1363158000"; 
   d="scan'208";a="355361216"
Date: Tue, 25 Jun 2013 14:16:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        b.brezillon@overkiz.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [GIT PULL v2] dmaengine: at_hdmac: updates for 3.11
Message-ID: <20130625084606.GL23141@intel.com>
References: <1372149389-18544-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372149389-18544-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:36:29AM +0200, Nicolas Ferre wrote:
> Vinod,
> 
> As said previously, I have collected the patches that can reach sdma git tree
> for 3.11.
> 
> This is the patch series that has already been sent by Ludovic and myself.
> It is the part of the series that is dedicated to dmaengine. It is based on
> slave-dma/next. 
> This set of patches update the dt dma binding for at_hdmac since we need one
> more parameter. In order to keep backward compatibility, an existing cell will
> be used to add this parameter. Since the content of that cell will become a
> magic value due to the concatenation of the two parameters, it is time to
> use macros.
> 
> I have also stacked some cleanup and trivial patches that were arround for some
> time plus the more recent conversion to the clock routines with
> prepare/unprepare variants.
> 
> Thanks, best regards,
> 
> v2 of pull-request: update of patch (dmaengine: at_hdmac: prepare clk before
>                     calling enable): removal of failing return code handling.
> 
> The following changes since commit fdf3303434787a4ba00a37a6748eb68974c63b0d:
> 
>   Merge branch 'for-linus' into next (2013-06-21 19:44:03 +0530)
> 
> are available in the git repository at:
> 
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-sdma
Pulled thanks

--
~Vinod

> 
> for you to fetch changes up to ee92c15c3a6244e51faa520c4e2ef6daeca80792:
> 
>   dmaengine: at_hdmac: prepare clk before calling enable (2013-06-25 10:27:18 +0200)
> 
> ----------------------------------------------------------------
> dmaengine updates for Atmel AT91 driver: at_hdmac.c
> - Device Tree binding update adding the use of header file for coding FIFO
>   configuration values
> - a warning removal
> - use of clk_prepare_enable/disable_unprepare in driver
> 
> ----------------------------------------------------------------
> Boris BREZILLON (1):
>       dmaengine: at_hdmac: prepare clk before calling enable
> 
> Ludovic Desroches (2):
>       ARM: at91: dt: add header to define at_hdmac configuration
>       dmaengine: at_hdmac: add FIFO configuration parameter to DMA DT binding
> 
> Nicolas Ferre (2):
>       dmaengine: at_hdmac: remove unsuded atc_cleanup_descriptors()
>       dmaengine/trivial: at_hdmac: add curly brackets to if/else expressions
> 
>  .../devicetree/bindings/dma/atmel-dma.txt          |  7 +-
>  drivers/dma/at_hdmac.c                             | 79 ++++++++++------------
>  include/dt-bindings/dma/at91.h                     | 27 ++++++++
>  3 files changed, 68 insertions(+), 45 deletions(-)
>  create mode 100644 include/dt-bindings/dma/at91.h
> 
> -- 
> Nicolas Ferre

-- 
