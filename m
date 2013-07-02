Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3GBM4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:56:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45136 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3GBM4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:56:50 -0400
Date: Tue, 2 Jul 2013 13:56:42 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Emilio Lopez <emilio@elopez.com.ar>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130702125642.GA10446@e102568-lin.cambridge.arm.com>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
 <51D2C3A9.5080809@atmel.com>
MIME-Version: 1.0
In-Reply-To: <51D2C3A9.5080809@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 02 Jul 2013 12:56:45.0781 (UTC) FILETIME=[9B905050:01CE7723]
X-MC-Unique: 113070213564801701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 01:12:25PM +0100, Nicolas Ferre wrote:
> On 28/06/2013 18:44, Maxime Ripard :
> > Hi Arnd, Olof,
> >
> > Sorry for steping in so late, but these two patches fixes a warning
> > introduced by the commit 1ba9bf0a (ARM: 7762/1: kernel: fix
> > arm_dt_init_cpu_maps() to skip non-cpu nodes) after 3.10-rc7.
> >
> > These two patches solve the situation for sunxi. The first one by
> > Lorenzo is to be applied for 3.10 if it's still possible, and the
> > second one on top of arm-soc/for-next. Tell me if you prefer a more
> > formal pull request for these patches
> 
> Just for the heads-up, the same happened to AT91 SAMA5D3.
> As the solution is already in linux-next, we simply have to make sure 
> that the patch is reported to the stable branches...

Not really. I dropped 1ba9bf0a (ARM 7762/1) from stable kernel queues, hence
if and when we decide to backport all these DT updates/fixes to stable kernels
we will have to do it in one go.

Let's postpone this decision until -rc1 is out.

Thanks,
Lorenzo

> 
> Bye,
> 
> 
> >
> > Thanks!
> > Maxime
> >
> > Lorenzo Pieralisi (1):
> >    ARM: dts: sunxi: cpus/cpu nodes dts updates
> >
> > Maxime Ripard (1):
> >    sunxi: a10s: dtsi: Convert cpu node to the new cpu bindings
> >
> >   arch/arm/boot/dts/sun4i-a10.dtsi  | 2 ++
> >   arch/arm/boot/dts/sun5i-a10s.dtsi | 2 ++
> >   arch/arm/boot/dts/sun5i-a13.dtsi  | 2 ++
> >   3 files changed, 6 insertions(+)
> >
> 
> 
> -- 
> Nicolas Ferre
> 

