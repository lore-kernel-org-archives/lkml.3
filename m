Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaF3JIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:08:13 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:39334 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaF3JIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:08:10 -0400
MIME-Version: 1.0
In-Reply-To: <1404066349.9064.60.camel@joe-AO725>
References: <20140626172852.GA2878@himangi-Dell>
	<1403804286.7977.58.camel@joe-AO725>
	<alpine.DEB.2.02.1406270729110.2016@localhost6.localdomain6>
	<1403848366.7977.92.camel@joe-AO725>
	<alpine.DEB.2.02.1406291832430.2036@localhost6.localdomain6>
	<1404066349.9064.60.camel@joe-AO725>
Date: Mon, 30 Jun 2014 11:08:08 +0200
X-Google-Sender-Auth: mMIWaqMRhnjcvAFHRVgIa8JfASo
Message-ID: <CAMuHMdWy-x4XimMDac1YtpSXZ4SnVN1zNKyQs6XPP7gvKOJBdg@mail.gmail.com>
Subject: Re: [PATCH] HID: roccat: Drop cast
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Himangi Saraogi <himangi774@gmail.com>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 8:25 PM, Joe Perches <joe@perches.com> wrote:
> I think I've seen code in the kernel like
>         char *p2 = (void *)p;
> where p is const and p2 is dereferenced and set.

I can imagine there's code like that.

Still hoping for gcc to gain an option to warn about all casts, except in header
files...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
