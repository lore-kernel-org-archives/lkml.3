Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750904Ab3KJISJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 03:18:09 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47171 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3KJISG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 03:18:06 -0500
MIME-Version: 1.0
In-Reply-To: <20131110055145.GA7947@chokladfabriken.org>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
	<20131110055145.GA7947@chokladfabriken.org>
Date: Sun, 10 Nov 2013 09:18:05 +0100
X-Google-Sender-Auth: PHq4sVAf90wFGT8WFLGbHutTc3k
Message-ID: <CAMuHMdVDvN=E1wJ4Od2gohfoqwmcQ=P7u_ehtWQb-23GQBgt_Q@mail.gmail.com>
Subject: Re: [ORLinux] [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Jonas Bonn <jonas@southpole.se>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>, linux@openrisc.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 6:51 AM, Stefan Kristiansson
<stefan.kristiansson@saunalahti.fi> wrote:
> On Sat, Nov 09, 2013 at 09:37:31PM +0100, Geert Uytterhoeven wrote:
>> Add a DTS and defconfig for the Terasic DE0-Nano Development and Education
>> Board running ORPSoC.  This board contains an Altera Cyclone IV FPGA with
>> support chips and I/O.
>>
>> The DTS was derived from published versions by Kevin Mehall and Marek
>> Czerski.
>
> To give credit where credit is due, this was created by:
> Gong Tao <gongtao0607@gmail.com>

Sorry, I didn't know that. Jonas: please add.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
