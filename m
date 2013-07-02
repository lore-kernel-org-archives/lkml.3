Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3GBMMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:12:32 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:12559 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3GBMMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:12:31 -0400
Message-ID: <51D2C3A9.5080809@atmel.com>
Date: Tue, 2 Jul 2013 14:12:25 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Emilio Lopez <emilio@elopez.com.ar>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/2013 18:44, Maxime Ripard :
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

Just for the heads-up, the same happened to AT91 SAMA5D3.
As the solution is already in linux-next, we simply have to make sure 
that the patch is reported to the stable branches...

Bye,


>
> Thanks!
> Maxime
>
> Lorenzo Pieralisi (1):
>    ARM: dts: sunxi: cpus/cpu nodes dts updates
>
> Maxime Ripard (1):
>    sunxi: a10s: dtsi: Convert cpu node to the new cpu bindings
>
>   arch/arm/boot/dts/sun4i-a10.dtsi  | 2 ++
>   arch/arm/boot/dts/sun5i-a10s.dtsi | 2 ++
>   arch/arm/boot/dts/sun5i-a13.dtsi  | 2 ++
>   3 files changed, 6 insertions(+)
>


-- 
Nicolas Ferre
