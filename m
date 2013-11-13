Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3KMWHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:07:31 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:36177 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3KMWHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:07:21 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 1/2] dmaengine: add msm bam dma driver
Date: Wed, 13 Nov 2013 23:07:19 +0100
Message-ID: <3732966.zLLfiChgvH@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20131030203105.GA14525@agross>
References: <1382732643-8184-1-git-send-email-agross@codeaurora.org> <20131029175603.GF21983@codeaurora.org> <20131030203105.GA14525@agross>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Wednesday 30 of October 2013 15:31:05 Andy Gross wrote:
> On Tue, Oct 29, 2013 at 10:56:03AM -0700, Stephen Boyd wrote:
> > On 10/25, Andy Gross wrote:
> > > diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> > > index f238cfd..a71b415 100644
> > > --- a/drivers/dma/Kconfig
> > > +++ b/drivers/dma/Kconfig
> > > @@ -364,4 +364,13 @@ config DMATEST
> > >  	  Simple DMA test client. Say N unless you're debugging a
> > >  	  DMA Device driver.
> > >  
> > > +
> > > +config MSM_BAM_DMA
> > > +	tristate "MSM BAM DMA support"
> > > +	depends on ARCH_MSM
> > 
> > It would be nice if we didn't have to rely on ARCH_MSM here so we
> > get more build coverage.
>  
> I can remove that.  There is nothing that forces this depend option.

Instead of removing, please add "|| COMPILE_TEST". This is the right way
to allow drivers not supposed to be run on given platform to build on it.

Best regards,
Tomasz

