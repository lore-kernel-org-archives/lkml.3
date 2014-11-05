Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaKESgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:36:14 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:65495 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaKESgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:36:10 -0500
MIME-Version: 1.0
In-Reply-To: <1415208392-16189-6-git-send-email-peter@hurleysoftware.com>
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
	<1415208392-16189-6-git-send-email-peter@hurleysoftware.com>
Date: Wed, 5 Nov 2014 19:36:07 +0100
X-Google-Sender-Auth: -vpuAL__7whfaMaGCxpPPPmcykY
Message-ID: <CAMuHMdWcWHg=VmxU7jjVXZAX2_=zEBaxsyHNwZQ+Rrxodc4OQQ@mail.gmail.com>
Subject: Re: [PATCH -next 5/9] serial: hp300: Remove obsolete comments
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 6:26 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> setup_serial_console() is obsolete and has been superseded by
> early_serial_setup() which is called at the end of the function.
>
> The IA64 arch does not call this function; only the m68k arch setup
> calls this function.
>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
