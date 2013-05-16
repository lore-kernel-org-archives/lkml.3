Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3EPLXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:23:13 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:52802 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3EPLXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:23:08 -0400
MIME-Version: 1.0
In-Reply-To: <ABCSCiTtUDvkm6WeI5J00000073@abc.logicbricks.com>
References: <9D79B9A9194389468A922F618415D0A401229E7E@abc.xylon.local>
	<20130515184112.251bb949@neptune.home>
	<ABCSCiTtUDvkm6WeI5J00000073@abc.logicbricks.com>
Date: Thu, 16 May 2013 13:23:07 +0200
X-Google-Sender-Auth: 3xFa3vf8_gtaZQEfl_kjdcZEeJA
Message-ID: <CAMuHMdUW-tVY6=Bu9mabKrkNJsTxJM+Umo6jjcnXpWpzh_5AVw@mail.gmail.com>
Subject: Re: fb driver for logiCVC
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Davor Joja <Davor.Joja@logicbricks.com>
Cc: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 12:35 PM, Davor Joja <Davor.Joja@logicbricks.com> wrote:
> Unfortunately, I have this driver on mentioned git only for few weeks, so there is no usable history.
> Since this is new driver, tested and functional (on kernel 3.8), without git history as stated above, do you have idea how to break it to smaller pieces? I can only think off as one big patch against 3.8.x version.
> That could be accepted for new driver?

A single patch is OK for a new driver.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
