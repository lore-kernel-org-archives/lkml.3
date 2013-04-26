Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab3DZHV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:21:58 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:33790 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3DZHV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:21:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130426170649.d21c2d7a74e56d836ff6f04f@canb.auug.org.au>
References: <20130426170649.d21c2d7a74e56d836ff6f04f@canb.auug.org.au>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 26 Apr 2013 09:21:36 +0200
Message-ID: <CACQ1gAidYqDm_SHea9jQFGqernZpgT8RuaRSP2N0ZPUX7JYyrA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the spi-mb tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wenyou Yang <wenyou.yang@atmel.com>,
        Mark Brown <broonie@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/26 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/boot/dts/at91sam9x5.dtsi between commits d50f88a0c304 ("ARM:
> dts: add spi nodes for atmel SoC") and a68b728f7a21 ("ARM: dts: add
> pinctrl property for spi node for atmel SoC") from the spi-mb tree and
> commits e9a72ee81d58 ("ARM: at91: dt: at91sam9x5: add i2c pinctrl"),
> 463c9c7bf1f3 ("ARM: at91: dt: at91sam9x5: add i2c-gpio pinctrl") and
> b909c6c94462 ("ARM: at91/at91sam9x5: add RTC node") from the arm-soc tree.
>
> I fixed it up (hopefully - see below) and can carry the fix as necessary
> (no action is required).

Hi,

It's all ok for me !

Thanks,

Richard.
