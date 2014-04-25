Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaDYItc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:49:32 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42274 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaDYIt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:49:27 -0400
MIME-Version: 1.0
In-Reply-To: <5359FB48.1020007@codesourcery.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<5354AD36.5090809@zytor.com>
	<CAFiDJ5861HE4AXtio-8uNJppWE2oaPt9_OKyGV=Myb_3vPrOVA@mail.gmail.com>
	<16597012.pEkDc99HDN@wuerfel>
	<CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com>
	<5357FF8E.9010809@codesourcery.com>
	<E780DB23-B6A3-427B-8F33-71378088A3F5@caviumnetworks.com>
	<5358AE96.9010006@codesourcery.com>
	<5358D17D.1040609@codesourcery.com>
	<20140424152819.GI8521@arm.com>
	<535959DF.6050009@codesourcery.com>
	<3AD1421B-E5FC-41F3-AE33-29655052DA4B@caviumnetworks.com>
	<5359FB48.1020007@codesourcery.com>
Date: Fri, 25 Apr 2014 10:49:26 +0200
X-Google-Sender-Auth: Oqn05Z4OgW2ZDjdWWugmiyocd7M
Message-ID: <CAMuHMdU9=G5fM0QgX5EhuLi3HMU==FDND7O3s8_Q291TNx+L0A@mail.gmail.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chung-Lin Tang <cltang@codesourcery.com>
Cc: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Andrew Pinski <apinski@cavium.com>,
        "Tang, Chung-Lin" <ChungLin_Tang@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 8:06 AM, Chung-Lin Tang <cltang@codesourcery.com> wrote:
> I'll try to explain a probable situation for Nios II. I'm not sure about
> other soft-cores, but nios2 is sort of uncommon in that the maximum
> alignment is 4-bytes (32-bits), even for doubles/long-longs.

FWIW, that's the same as on m32r. And on m68k it's 2 bytes.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
