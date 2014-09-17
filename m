Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaIQLJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:09:24 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46695 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaIQLJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <1410538794.8852.35.camel@AMDC723>
References: <1410348536-15201-1-git-send-email-m.matraszek@samsung.com>
	<CAMuHMdUi9sZFZa2pcAWvHi1xmZfhEUyCbW0uRt65QwkbTqEjYg@mail.gmail.com>
	<1410453908.8852.9.camel@AMDC723>
	<CAMuHMdV74C+iFXXGjKAfvjd8NjKQDwcm1bJja41cscbip_ePZg@mail.gmail.com>
	<1410538794.8852.35.camel@AMDC723>
Date: Wed, 17 Sep 2014 13:09:18 +0200
X-Google-Sender-Auth: h7Zwx74l6L6HUgWjrIjAJFpPmtQ
Message-ID: <CAMuHMdUCNCfXJt8eP++Qzx108gujcavJJYZPL7hiYwOPtC96fw@mail.gmail.com>
Subject: Re: [PATCH] PM / Domains: add debugfs listing of struct generic_pm_domain-s
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Maciej Matraszek <m.matraszek@samsung.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Fri, Sep 12, 2014 at 6:19 PM, Maciej Matraszek
<m.matraszek@samsung.com> wrote:
>> > (though 'runtime status' alignment seems odd).
>>
>> What's wrong with it?
>
> Nothing big, just for such short device names it doesn't look aesthetic to me :).

In legacy mode, using platform code (without DT), the device names are
longer :-)

BTW, the list of slaves is indented by two more spaces than the column title:

    domain                      status         slaves
a4s                             on               a3sp, a3sm, a3sg

This is also the case in V2.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
