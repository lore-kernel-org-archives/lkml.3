Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3EMPh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:37:27 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:32023 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3EMPh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:37:26 -0400
Date: Mon, 13 May 2013 17:37:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: davem@davemloft.net, daniel@gaisler.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: sparc: kernel: use devm_ioremap_resource()
Message-ID: <20130513153721.GA18836@merkur.ravnborg.org>
References: <1368367807-1263-1-git-send-email-laurent.navet@gmail.com> <20130512152829.GA17866@merkur.ravnborg.org> <CAH7P7NjHK+QQ1E1ygCG0u=oEL1=Dty__OAZfYA1bitPm_cY3Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH7P7NjHK+QQ1E1ygCG0u=oEL1=Dty__OAZfYA1bitPm_cY3Yw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 01:43:17PM +0200, Laurent Navet wrote:
> The same is done almost everywhere in kernel tree :
> 
> e.g :
> http://lxr.free-electrons.com/source/drivers/staging/iio/adc/mxs-lradc.c#L928
> http://lxr.free-electrons.com/source/drivers/gpio/gpio-mxs.c#L292
> http://lxr.free-electrons.com/source/drivers/iommu/tegra-smmu.c#L1181
> http://lxr.free-electrons.com/source/drivers/rtc/rtc-spear.c#L388
> http://lxr.free-electrons.com/source/drivers/i2c/busses/i2c-imx.c#L514
> http://lxr.free-electrons.com/source/sound/soc/kirkwood/kirkwood-i2s.c#L475
> 
> and so on...  all theses functions return an int.

I was confusing PTR_ERR() and ERR_PTR(),
so path looks ok.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
