Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaBXA2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:28:46 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:43513 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBXA2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:28:44 -0500
Date: Mon, 24 Feb 2014 09:28:40 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH v2 1/2] ARM: shmobile: r8a7778/r8a7779 dtsi: Improve and
 correct HSPI bindings
Message-ID: <20140224002837.GA3898@verge.net.au>
References: <1392908239-22645-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392908239-22645-1-git-send-email-geert@linux-m68k.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 03:57:18PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Binding documentation:
>   - Add future-proof "renesas,hspi-<soctype>" compatible values,
>   - Add "interrupt-parent", "#address-cells" and "#size-cells" properties,
>   - Add reference to pinctrl documentation,
>   - Add example bindings.
> 
> r8a7778 and r8a7779 dtsi:
>   - Add "renesas,hspi-r8a7778" resp. "renesas,hspi-r8a7779" compatible
>     values,
>   - Correct reference to parent interrupt controller
>     (use "interrupt-parent" instead of "interrupt-controller"),
>   - Add missing "#address-cells" and "#size-cells" properties, which are
>     needed when populating the SPI buses.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Tested-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> [HSPI/BockW]
> Cc: Mark Brown <broonie@linaro.org>
> ---
> v2:
>   - Add Tested-by
>   - List full example compatible properties with soctypes instead of just
>     the soctypes, so checkpatch can validate DTSes.

Thanks, I have queued this up.
