Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3EXJes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:34:48 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48872 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3EXJer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:34:47 -0400
Date: Fri, 24 May 2013 11:34:44 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH -next] pinctrl: sunxi: fix error return code in
 sunxi_pinctrl_probe()
Message-ID: <20130524093444.GA8785@lukather>
References: <CAPgLHd_v3oNBP5DcqJ9bkGKkCDqwr1UzJNnVT6uz8V--FWEQ0Q@mail.gmail.com>
 <CACRpkdbAhSRLpvLt8K8suL57cs7ts7rH-SqHJgQc1LA96=JO8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbAhSRLpvLt8K8suL57cs7ts7rH-SqHJgQc1LA96=JO8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, May 24, 2013 at 11:23:04AM +0200, Linus Walleij wrote:
> On Thu, May 23, 2013 at 11:32 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> 
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > Fix to return a negative error code from the devm_clk_get() error
> > handling case instead of 0, as done elsewhere in this function.
> >
> > Introduced by commit 950707c0eb5c7aeaa2c446a04c824f4be686d2f6
> > (pinctrl: sunxi: add clock support)
> >
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Patch applied for fixes, thanks!
> 
> Maxime: OK?

Yes, everything's fine for me.

Thanks!
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
