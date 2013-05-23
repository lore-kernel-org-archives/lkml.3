Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab3EWLXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:23:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:38117 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179Ab3EWLX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:23:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,728,1363158000"; 
   d="scan'208";a="306760039"
Date: Thu, 23 May 2013 16:16:58 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 10/63] dmaengine: ste_dma40: Amalgamate DMA source and
 destination channel numbers
Message-ID: <20130523104658.GF30200@intel.com>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-11-git-send-email-lee.jones@linaro.org>
 <CACRpkdai7y+LBiFyK+b-CvW6p7n+TbC1iX0+XiLyg2V_8rFL+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdai7y+LBiFyK+b-CvW6p7n+TbC1iX0+XiLyg2V_8rFL+A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 02:35:01PM +0200, Linus Walleij wrote:
> On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Devices which utilise DMA use the same device numbers for transmitting
> > and receiving. In this patch we encode the source and destination
> > information into one single attribute. We can subsequently exploit the
> > direction attribute to see which of the transfer directions are being
> > described. This also lessens the burden on platform data.
> >
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Per Forlin <per.forlin@stericsson.com>
> > Cc: Rabin Vincent <rabin@rab.in>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Still waiting for an ACK from Vinod on this as well.
Here you go...

Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
> 
> Vinod?
> 
> Yours,
> Linus Walleij
