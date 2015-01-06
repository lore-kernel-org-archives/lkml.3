Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbbAFVjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:39:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48064 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932611AbbAFVjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:39:07 -0500
Message-ID: <54AC557D.1080605@free-electrons.com>
Date: Tue, 06 Jan 2015 18:37:01 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ken Wilson <ken.wilson@opengear.com>, robh+dt@kernel.org
CC: pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, broonie@kernel.org,
        gerg@uclinux.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH] spi: orion: Add multiple chip select support for Armada
 370 and 375
References: <1420579846-31962-1-git-send-email-ken.wilson@opengear.com>
In-Reply-To: <1420579846-31962-1-git-send-email-ken.wilson@opengear.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 06:30 PM, Ken Wilson wrote:
> Create a new dt binding for the Armada 375 that supports up to
> 3 chip selects but uses the same prescaler values and algorithm
> as the basic orion binding.
> 
> Update the Armada 370 so that it supports up to 4 chip selects.
> 
> This has been tested on the Armada 375 with multiple SPI-NOR chips.
> 
> Signed-off-by: Ken Wilson <ken.wilson@opengear.com>
> ---
>  .../devicetree/bindings/spi/spi-orion.txt          |  3 ++-
>  arch/arm/boot/dts/armada-375.dtsi                  |  4 +--
>  drivers/spi/spi-orion.c                            | 29 +++++++++++++++++++---

You will have to split this changeset in three patches, given these
three files carry different kind of changes:

1. The driver change itself
2. The devicetree binding documentation change
3. The devicetree dtsi change

Regards,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
