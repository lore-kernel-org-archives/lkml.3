Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaIKR1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:27:33 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:56408 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaIKR1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:27:31 -0400
MIME-Version: 1.0
In-Reply-To: <1410453908.8852.9.camel@AMDC723>
References: <1410348536-15201-1-git-send-email-m.matraszek@samsung.com>
	<CAMuHMdUi9sZFZa2pcAWvHi1xmZfhEUyCbW0uRt65QwkbTqEjYg@mail.gmail.com>
	<1410453908.8852.9.camel@AMDC723>
Date: Thu, 11 Sep 2014 19:27:29 +0200
X-Google-Sender-Auth: x5sDVBtaeMgOQda_ah9MbSFgpH8
Message-ID: <CAMuHMdV74C+iFXXGjKAfvjd8NjKQDwcm1bJja41cscbip_ePZg@mail.gmail.com>
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

On Thu, Sep 11, 2014 at 6:45 PM, Maciej Matraszek
<m.matraszek@samsung.com> wrote:
> BTW Can I use your output as example in the commit message for v2?
> It's much more informative

Sure, no problem.

> (though 'runtime status' alignment seems odd).

What's wrong with it?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
