Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3KLTys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:54:48 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40058 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3KLTyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:54:39 -0500
MIME-Version: 1.0
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 12 Nov 2013 20:54:38 +0100
X-Google-Sender-Auth: MEGeZf6m5pUCehmSgYIkV0aMzbc
Message-ID: <CAMuHMdXC_bkBPvhF4ZM6oTS3kxsaU8-hYhOSQNY8thgF-xJC8A@mail.gmail.com>
Subject: Re: [PATCH 00/17] <asm/sections.h> related cleanups
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>, Jonas Bonn <jonas@southpole.se>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux@openrisc.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 8:42 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> This started as a small cleanup in the OpenRISC code, but then I got
> pulled into the pool of all section-related symbols, many of which are
> different or duplicated.

Bummer, I forgot the two OpenRISC commits that started it all
(too high up in my commit chain). Will send...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
