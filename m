Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaCEIbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:31:46 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:61496 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaCEIbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:31:43 -0500
MIME-Version: 1.0
In-Reply-To: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
References: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 5 Mar 2014 17:31:42 +0900
Message-ID: <CANqRtoSM-51NRVAtYOOAzZQ-pagC2JteC+M=SKMuBYniLFfhLA@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] ARM: shmobile: MSIOF integration on
 r8a7790/lager and r8a7791/koelsch
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Simon Horman <horms@verge.net.au>, SH-Linux <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 7:30 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>         Hi Simon, Magnus,
>
> This patch series integrates support for the MSIOF module in the Renesas
> R-Car H2 (r8a7790) and M2 (r8a7791) SoCs on the Lager and Koelsch
> development boards.
>
> It was tested on Lager and Koelsch, both legacy and DT, using a dummy
> driver for the Renesas r2a11302ft PMIC that reads out the PMIC's version
> ID.
>
>     [01/11] ARM: shmobile: r8a7790: Add MSIOF clocks
>     [02/11] ARM: shmobile: r8a7791: Add MSIOF clocks
>     [03/11] ARM: shmobile: lager legacy: Add MSIOF support
>     [04/11] ARM: shmobile: koelsch legacy: Add MSIOF support
>     [05/11] ARM: shmobile: r8a7790/lager dts: Rename label spi to qspi, add
>             spi0 alias
>     [06/11] ARM: shmobile: r8a7791/koelsch dts: Rename label spi to qspi,
>             add spi0 alias
>     [07/11] ARM: shmobile: r8a7790 dtsi: Add MSIOF nodes and aliases
>     [08/11] ARM: shmobile: r8a7791 dtsi: Add MSIOF nodes and aliases
>     [09/11] ARM: shmobile: lager dts: Add MSIOF nodes
>     [10/11] ARM: shmobile: koelsch dts: Add MSIOF nodes
>     [11/11] ARM: shmobile: koelsch/lager/multi defconfig: Enable MSIOF
>
> These are (reworked versions of) the remaining patches not taken from v1.
> Changelogs are available in the individual patches.

Hi Geert,

Thanks for your efforts. All these look fine to me.

Acked-by: Magnus Damm <damm@opensource.se>

Exactly what to merge upstream depends on what the ARM SoC maintainers prefer.

Cheers,

/ magnus
