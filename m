Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbbAMCDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:03:16 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:39257 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbAMCDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:03:14 -0500
Date: Mon, 12 Jan 2015 18:03:25 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, khilman@kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        ARM Maintainers <arm@kernel.org>
Subject: Re: [PATCH] ARM: at91/Documentation: add a README for Atmel SoCs
Message-ID: <20150113020325.GB28758@quad.lixom.net>
References: <1420809631-26923-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420809631-26923-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 02:20:31PM +0100, Nicolas Ferre wrote:
> Add a README file to describe Atmel SoCs (aka AT91) support in Mainline Linux:
> - SoC list + datasheet web links
> - Basic but useful information
> - Device Tree conventions and Work In Progress statement.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: ARM Maintainers <arm@kernel.org>

Acked-by: Olof Johansson <olof@lixom.net>

With the understanding that:

> +Device Tree for AT91 SoCs and boards
> +------------------------------------
> +All AT91 SoCs are converted to Device Tree. Since Linux 3.19, these products
> +must use this method to boot the Linux kernel.
> +
> +Work In Progress statement:
> +Device Tree files and Device Tree bindings that apply to AT91 SoCs and boards are
> +considered as "Unstable". To be completely clear, any at91 binding can change at
> +any time. So, be sure to use a Device Tree Binary and a Kernel Image generated from
> +the same source tree.
> +Please refer to the Documentation/devicetree/bindings/ABI.txt file for a
> +definition of a "Stable" binding/ABI.
> +This statement will be removed by AT91 MAINTAINERS when appropriated.

While this statement is here, at the end of the day if you break a user
you're responsible for fixing them. I.e. if a tree falls in the forest
and nobody notices, then so be it.

But you can't break existing users and point to this and get away with
it. However, hopefully based on this doc users will go with practices
that means that you can revise bindings if you have to.


-Olof
