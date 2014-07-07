Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaGGHZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 03:25:33 -0400
Received: from gloria.sntech.de ([95.129.55.99]:52218 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaGGHZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 03:25:30 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@kernel.org>
Cc: addy ke <addy.ke@rock-chips.com>, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, olof@lixom.net, hj@rock-chips.com,
        kever.yang@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, wei.luo@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 2/2] spi: add driver for Rockchip RK3xxx SoCs integrated SPI
Date: Mon, 07 Jul 2014 09:26:52 +0200
Message-ID: <2620380.GejlhFPJDO@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140707072140.GB30458@sirena.org.uk>
References: <1403582852-9751-1-git-send-email-addy.ke@rock-chips.com> <5578791.jcBVzrGadW@diego> <20140707072140.GB30458@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 7. Juli 2014, 08:21:40 schrieb Mark Brown:
> On Mon, Jul 07, 2014 at 09:08:41AM +0200, Heiko Stübner wrote:
> > Am Montag, 7. Juli 2014, 09:42:52 schrieb addy ke:
> > > > Your DT binding defined some additional compatible strings, please add
> > > > those to the driver.
> > 
> > citing Mark Rutland (one of the dt maintainers):
> > 
> > --
> > 
> >   That's why I said in addition to the common one. I'd only expect the
> >   
> >   driver to look for "rockchip,rk3066-spi", but a DTB could have:
> >         compatible = "rockchip,rk3188-spi", "rockchip,rk3066-spi";
> >   
> >   Seeding the DTBs with the extra strings early makes it more likely that
> >   we can rely on them later. If we don't happen to need them they only
> >   clutter some DTBs.
> > 
> > --
> > 
> > so it looks like the driver is doing the right thing right now
> 
> The driver will work but it's better to list the strings that are
> supported explicitly if only to document that there's nothing specific
> Linux should be doing for them.

ok, makes sense :-)
