Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab3GDIK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:10:58 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:41840 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3GDIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:10:55 -0400
MIME-Version: 1.0
In-Reply-To: <1372916353-24050-5-git-send-email-paul.gortmaker@windriver.com>
References: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
	<1372916353-24050-5-git-send-email-paul.gortmaker@windriver.com>
Date: Thu, 4 Jul 2013 10:10:55 +0200
X-Google-Sender-Auth: ZJSqCjn1rn0gIH6H-iEy-ya613g
Message-ID: <CAMuHMdWu9j5BC-boVkUfVPUnVZdbaA=UnSJ=5xm3Q8d1JOsbGw@mail.gmail.com>
Subject: Re: [PATCH 4/4] checkpatch: only allow COMPILE_TEST in Kconfig
 dependency lines
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 4, 2013 at 7:39 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> With that in mind, it is clear that this is _not_ to be used in
> any C code with "#ifdef CONFIG_COMPILE_TEST" etc.  However there
> will (and already has been) instances of people thinking this is
> an OK practice[2].  So teach checkpatch to spot them as an error.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
