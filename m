Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3FZLTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:19:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:4254 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab3FZLTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:19:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,943,1363158000"; 
   d="scan'208";a="359834628"
Date: Wed, 26 Jun 2013 16:09:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Brown <broonie@kernel.org>
Cc: Jonathan Austin <jonathan.austin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, linus.walleij@linaro.org,
        Will Deacon <will.deacon@arm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: amba-pl08x and 'get_signal' namespace collision/build error
Message-ID: <20130626103930.GS23141@intel.com>
References: <51C97F40.5030101@arm.com>
 <20130625184539.GB2718@n2100.arm.linux.org.uk>
 <20130626044842.GR23141@intel.com>
 <20130626081909.GD2718@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626081909.GD2718@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 09:19:09AM +0100, Russell King - ARM Linux wrote:
> On Wed, Jun 26, 2013 at 10:18:42AM +0530, Vinod Koul wrote:
> > Yup. This is fixed in slave-dma tree by a patch from mark by renaming it.
> > 
> > This should not show in the -next tree
> 
> Except, that change probably is probably responsible for this new error:
> 
> drivers/dma/amba-pl08x.c: In function 'pl08x_request_mux':
> drivers/dma/amba-pl08x.c:304:13: error: expected identifier before '(' token
This was pushed four days ago and havent seen any error report expect this.

Anyway I rebuild my -next and looks fine for me

  CC      drivers/dma/dmaengine.o
  CC      drivers/dma/virt-dma.o
  CC      drivers/dma/iovlock.o
  CC [M]  drivers/dma/dmatest.o
  CC      drivers/dma/amba-pl08x.o
  LD      drivers/dma/built-in.o

Can you share your config which failed for you?

Mark, I believe you are testing for this, have you seen above error?

--
~Vinod
