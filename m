Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3E3SL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:11:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:11397 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab3E3SLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:11:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,772,1363158000"; 
   d="scan'208";a="342660417"
Date: Thu, 30 May 2013 23:03:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Dan Williams <djbw@fb.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next v2] dmaengine: ste_dma40: fix error return code
 in d40_probe()
Message-ID: <20130530173326.GD3767@intel.com>
References: <CAPgLHd-gjJ6ju3HyhiQi98YFGojvU3aYSTn7SOe4NhQPY1r++w@mail.gmail.com>
 <CACRpkdYBfvr0kA7bd-6Ns78UH7JtBCFDzFxyHLgtReB32O4D+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYBfvr0kA7bd-6Ns78UH7JtBCFDzFxyHLgtReB32O4D+w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 09:41:38AM +0200, Linus Walleij wrote:
> On Thu, May 30, 2013 at 6:32 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> 
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > In many of the error handling case, the return value 'ret' not set
> > and 0 will be return from d40_probe() even if error, but we should
> > return a negative error code instead in those error handling case.
> > This patch fixed them, and also removed useless variable 'err'.
> >
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > ---
> > v1 -> v2: rebased on linux-next.git
> 
> I've tentatively applied this to my dma40 branch, waiting for Vinod
> to ACK it.
I though you wanted me to apply this :)

Nevertheless, Acked-by: Vinod Koul <vinod.koul@intel.com>

Can you CC stable too, pls.

--
~Vinod

-- 
