Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaKYNAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:00:33 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:63054 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbaKYNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:00:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, catalin.marinas@arm.com,
        gregkh@linuxfoundation.org, ijc+devicetree@hellion.org.uk,
        jslaby@suse.cz, galak@codeaurora.org, broonie@linaro.org,
        mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com,
        artagnon@gmail.com, rrichter@cavium.com, will.deacon@arm.com,
        gnomes@lxorguk.ukuu.org.uk, corbet@lwn.net, jason@lakedaemon.net,
        broonie@kernel.org, heiko@sntech.de, shawn.guo@freescale.com,
        florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com,
        orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        zhang.lyra@gmail.com, wei.qiao@spreadtrum.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sprdlinux@freelists.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3 0/5] Add Spreadtrum Sharkl64 Platform support
Date: Tue, 25 Nov 2014 13:59:42 +0100
Message-ID: <5003189.80rNq67D5Z@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:u/BJiuK4i6hacAwBgqOlIgAh62weszCE9foDRXxM37I
 wJ7c+8LjaZz6MyfhFo3DeoagrQIFGueI2nkRCzPGZY3xPgKvTW
 f3yBU/wU/abS/kb0JHcQpMCY7UkHrocnd5bzJYTkIsBAc2ow0e
 A7vB8TvxTQdx+jVy+MczeVrYGd8MqEGVHx1qAVt5fhyvfN6H+m
 Mf1zQNzMipSa5CiwgUVpyf2BpR9Hb+A2tcaLPXaVGhL8UdQeXK
 sOlOVeFz2N3mj4QiLYJkM0eXjbX31n9iy1xk32UwFlrnAjiE7G
 oz4LjswXDrrusgdaxVqEaLHE7bPnNAupypftodw/wl9yoUt2Rl
 mgjG/jlMTY0ccFOTbqHk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2014 20:16:53 Chunyan Zhang wrote:
> Spreadtrum is a rapid growing chip vendor providing smart phone total solutions.
> 
> Sharkl64 Platform is nominated as a SoC infrastructure that supports 4G/3G/2G
> standards based on ARMv8 multiple core architecture.Now we have only one
> SoC(SC9836) based on this Platform in developing.
> 
> This patchset adds Sharkl64 support in arm64 device tree and the serial driver
> of SC9836-UART.
> 
> This patchset also has patches which address "sprd" prefix and DT compatible
> strings for nodes which appear un-documented.
> 
> This version code was tesed on Fast Mode.
> We use boot-wrapper-aarch64 as the bootloader.

Looks very good overall. I have two small comments to individual patches,
but I think we can still merge them for 3.19. Please send the serial
driver to Greg for inclusion, unless you get further comments, and send
the updated version of the other patches to arm@kernel.org and ask
for including them in the cover letter.

	Arnd
