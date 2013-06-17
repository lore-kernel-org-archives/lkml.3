Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab3FQOa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:30:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:6944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab3FQOa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:30:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="256151288"
Date: Mon, 17 Jun 2013 19:20:28 +0530
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
Message-ID: <20130617135028.GE10671@intel.com>
References: <CAPgLHd-gjJ6ju3HyhiQi98YFGojvU3aYSTn7SOe4NhQPY1r++w@mail.gmail.com>
 <CACRpkdYBfvr0kA7bd-6Ns78UH7JtBCFDzFxyHLgtReB32O4D+w@mail.gmail.com>
 <20130530173326.GD3767@intel.com>
 <CACRpkdZhK6TUAC132vzcaLKqdMTwPma+ZhKG5Y+AUvekNpz6EQ@mail.gmail.com>
 <20130612095443.GU4107@intel.com>
 <CACRpkdYS8MYEBs_kcGyOPvcenBALxAXtksRA=+TmkeyOZW=Xzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYS8MYEBs_kcGyOPvcenBALxAXtksRA=+TmkeyOZW=Xzg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 09:49:04AM +0200, Linus Walleij wrote:
> On Wed, Jun 12, 2013 at 11:54 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> 
> >> Let me know how you want it, I've removed it from my
> >> dma40 branch for the time being.
> >
> > Have you removed, Also I see a v3 of this, do you want to ack that before I
> > apply
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I haven't sent this patch to ARM SoC so it will not appear from any other source
> in the merge window or cause any conflicts.
Doesnt apply on my next or -rc6. I think it has some ste dependecies. So either
we wait and I send this for next -rc2 or you apply with my Ack

--
~Vinod
