Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbbAHT2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:28:50 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:41104 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbbAHT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:28:48 -0500
MIME-Version: 1.0
In-Reply-To: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
References: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
Date: Thu, 8 Jan 2015 20:28:45 +0100
X-Google-Sender-Auth: l-6d3OXYYRnkHFKEbLhelsMs5xE
Message-ID: <CAMuHMdVeEmKiqGTOmevaBDbJ=nBTbSi6d6Xrm0eyvbMTtyU=sA@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Add Simple Power-Managed Bus Support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 7:49 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> The Renesas Bus State Controller (BSC) provides an external bus for
> connecting multiple external devices to an SoC, driving several chip
> select lines, for e.g. NOR FLASH, Ethernet and USB.
> On the kzm9g and ape6evm development boards, an smsc9220 Ethernet
> controller is connnected to the BSC of an SH-Mobile AG5 (sh73a0) resp.
> R-Mobile APE6 (r8a73a4) SoC.

[...]

> This was tested on sh73a0/kzm9g-multiplatform. Without this, Ethernet
> doesn't work, as the ZB clock is disabled by clk_disable_unused().
> Testing on r8a73a4/ape6evm-multiplatform would be appreciated.

Has anyone tried this on r8a73a4/ape6evm-multiplatform?

Thanks again!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
