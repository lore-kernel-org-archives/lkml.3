Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3GYJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:58:25 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:41383 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3GYJ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <51F09D5E.70304@cn.fujitsu.com>
References: <51F09D5E.70304@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 11:58:21 +0200
X-Google-Sender-Auth: JFIV3uuqZLcBF8PTpF43UFAlYMM
Message-ID: <CAMuHMdVxXLrUXQno+vtHQrT_mmc9C6q42HZ6F1TujLBeEZt+Mw@mail.gmail.com>
Subject: Re: [PATCH] driver/vga16fb.c: remove the unused variable "dev" of
 function vga16fb_destroy()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 5:37 AM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> Commit  e21d2170f36602ae2708 removed the unnecessary platform_set_drvdata(),
> but left the variable "dev" unused, delete it.

When referring to another commit, please also include the oneline summary of
the commit, to make it easier for people to see what it's about.

E.g. "Commit  e21d2170f36602ae2708 ("video: remove unnecessary
platform_set_drvdata()") removed the unnecessary platform_set_drvdata(),
but left the variable "dev" unused, delete it."

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
