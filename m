Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaIZJ1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:27:31 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:47963 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaIZJ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:27:28 -0400
MIME-Version: 1.0
In-Reply-To: <3136347.ncZoJtR6MK@vostro.rjw.lan>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
	<3136347.ncZoJtR6MK@vostro.rjw.lan>
Date: Fri, 26 Sep 2014 11:27:26 +0200
X-Google-Sender-Auth: m27aJ0hNLTFE4dBA-TTgXomoNLA
Message-ID: <CAMuHMdXJPQjRQip+YY0jysR5pzU3hEz-QQ6C-GZQmDKqU1TreA@mail.gmail.com>
Subject: Re: [PATCH 00/13] ARM: shmobile: R-Mobile: DT PM domain support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Thu, Sep 25, 2014 at 10:19 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> Rafael: If you accept "PM / Domains: Add genpd attach/detach callbacks", it
>> would be good to get this patch in v3.18-rc1, as it's the only hard dependency
>> on linux-pm.git for the rest of this series. The other parts have relaxed
>> ordering constraints due to the separation of code and DTS.
>
> OK, this one looks good to me, so I can push it for 3.18.

Thank you very much!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
