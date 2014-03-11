Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaCKNOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:14:02 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51077 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaCKNOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140311124006.GA14565@amd.pavel.ucw.cz>
References: <1394536091-28881-1-git-send-email-geert@linux-m68k.org>
	<20140311124006.GA14565@amd.pavel.ucw.cz>
Date: Tue, 11 Mar 2014 14:13:59 +0100
X-Google-Sender-Auth: gfJwMVQD1jen0qDNNq0U0ZUTzDo
Message-ID: <CAMuHMdVPLMm90aSHfY5UugMgX93iT61Q+oTW72CK-x-huNuRjg@mail.gmail.com>
Subject: Re: [PATCH v2] PM: Add missing "freeze" state
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Tue, Mar 11, 2014 at 1:40 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2014-03-11 12:08:11, Geert Uytterhoeven wrote:
>> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks!

> Is it going to go in through the trivial tree?

I didn't send this to trivial, so please take it through the PM tree.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
