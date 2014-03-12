Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaCLSzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:55:54 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60390 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaCLSzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:55:51 -0400
MIME-Version: 1.0
In-Reply-To: <1394557846.21085.54.camel@joe-AO722>
References: <1394532680-4264-1-git-send-email-geert@linux-m68k.org>
	<1394548060.21085.45.camel@joe-AO722>
	<1394557846.21085.54.camel@joe-AO722>
Date: Wed, 12 Mar 2014 19:55:50 +0100
X-Google-Sender-Auth: udSy1M6I6fQb4GOYANdMSYI9D1M
Message-ID: <CAMuHMdXkLkMOhoiqJ8cxZMUm6SnaxC5WV=a2w=bv1=KW6nyqwQ@mail.gmail.com>
Subject: Re: [PATCH] serial: sh-sci: Neaten dev_<level> uses
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-serial@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, Mar 11, 2014 at 6:10 PM, Joe Perches <joe@perches.com> wrote:
> Add missing newlines and coalesce formats.
> Realign arguments.

Thanks!

> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
