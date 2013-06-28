Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3F1RPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:15:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42859 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3F1RPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:15:37 -0400
Date: Fri, 28 Jun 2013 18:15:32 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130628171532.GD30603@e102568-lin.cambridge.arm.com>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
In-Reply-To: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 28 Jun 2013 17:15:33.0799 (UTC) FILETIME=[1954D370:01CE7423]
X-MC-Unique: 113062818153500201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 05:44:02PM +0100, Maxime Ripard wrote:
> Hi Arnd, Olof,
> 
> Sorry for steping in so late, but these two patches fixes a warning
> introduced by the commit 1ba9bf0a (ARM: 7762/1: kernel: fix
> arm_dt_init_cpu_maps() to skip non-cpu nodes) after 3.10-rc7.
> 
> These two patches solve the situation for sunxi. The first one by
> Lorenzo is to be applied for 3.10 if it's still possible, and the
> second one on top of arm-soc/for-next. Tell me if you prefer a more
> formal pull request for these patches
> 
> Thanks!
> Maxime
> 
> Lorenzo Pieralisi (1):
>   ARM: dts: sunxi: cpus/cpu nodes dts updates

The patch above should already be queued in next/dt right ?

Thanks,
Lorenzo

> 
> Maxime Ripard (1):
>   sunxi: a10s: dtsi: Convert cpu node to the new cpu bindings
> 
>  arch/arm/boot/dts/sun4i-a10.dtsi  | 2 ++
>  arch/arm/boot/dts/sun5i-a10s.dtsi | 2 ++
>  arch/arm/boot/dts/sun5i-a13.dtsi  | 2 ++
>  3 files changed, 6 insertions(+)
> 
> -- 
> 1.8.3.1
> 
> 

