Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaBZINW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:13:22 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:47903 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaBZINU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:13:20 -0500
MIME-Version: 1.0
In-Reply-To: <1393323673-2751-1-git-send-email-geert@linux-m68k.org>
References: <1393323673-2751-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 26 Feb 2014 17:13:18 +0900
Message-ID: <CANqRtoSBrLA_LsL1HiYbHqADPmiyLhAr_MszMuae-8zMTQn=bw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] spi: sh-msiof: Add support for R-Car H2 and M2
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        linux-spi@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 7:21 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>         Hi Mark,
>
> This patch series refactors the sh-msiof SPI driver and adds support for
> the MSIOF variant in the Renesas R-Car H2 (r8a7790) and M2 (r8a7791) SoCs.
>
> It was tested on the Lager and Koelsch development boards, using a dummy
> driver for the Renesas r2a11302ft PMIC that reads out the PMIC's version ID.
>
>     [1/6] spi: sh-msiof: Improve bindings
>     [2/6] spi: sh-msiof: Move default FIFO sizes to device ID data
>     [3/6] spi: sh-msiof: Add support for R-Car H2 and M2
>     [4/6] spi: sh-msiof: Move clock management to (un)prepare_message()
>     [5/6] spi: sh-msiof: Convert to let spi core validate xfer->bits_per_word
>     [6/6] spi: sh-msiof: Use core message handling instead of spi-bitbang
>
> These are (reworked versions of) the remaining patches not taken from v1.
> Changelogs are available in the individual patches.
>
> Some of this work was based on a patch series by Takashi Yoshii
> <takasi-y@ops.dti.ne.jp>.

Hi Geert,

Thanks for this updated version. I like the way you reworked the DT
bindings to let the FIFO configuration stay in the driver. Also
getting rid of the now-not-needed bitbang dependency is a great thing.
All these patches look good to me.

Acked-by: Magnus Damm <damm@opensource.se>

Cheers,

/ magnus
