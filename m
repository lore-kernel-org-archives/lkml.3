Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbaGJAiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:38:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbaGJAiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:38:21 -0400
Date: Wed, 9 Jul 2014 17:42:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH char-misc-next v2 3/8] dma: MIC X100 DMA Driver
Message-ID: <20140710004246.GD4950@kroah.com>
References: <cover.1401397315.git.sudeep.dutt@intel.com>
 <334a1f0e362e9a695a2cdc8dcabb52a98e0d4643.1401397315.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <334a1f0e362e9a695a2cdc8dcabb52a98e0d4643.1401397315.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 02:24:00PM -0700, Sudeep Dutt wrote:
> From: Siva Yerramreddy <yshivakrishna@gmail.com>
> 
> This patch implements DMA Engine API for DMA controller on MIC X100
> Coprocessors. DMA h/w is shared between host and card s/w.
> Channels 0 to 3 are used by host and 4 to 7 are used by card.
> Since the DMA device doesn't show up as PCIe device, a virtual bus called mic
> bus is created and virtual devices are added on that bus to follow device model.
> Allowed dma transfer directions are host to card, card to host and card to card.
> 
> Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
> Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
> Signed-off-by: Siva Yerramreddy <yshivakrishna@gmail.com>
> ---
>  drivers/dma/Kconfig        |  19 ++
>  drivers/dma/Makefile       |   1 +
>  drivers/dma/mic_x100_dma.c | 774 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/dma/mic_x100_dma.h | 286 +++++++++++++++++
>  4 files changed, 1080 insertions(+)
>  create mode 100644 drivers/dma/mic_x100_dma.c
>  create mode 100644 drivers/dma/mic_x100_dma.h

I need some drivers/dma/ maintainers to review this one please...

