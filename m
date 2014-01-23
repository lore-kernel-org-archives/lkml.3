Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaAWU1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:27:50 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:38954 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaAWU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:27:48 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1401231306220.31739@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231305390.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231306220.31739@file01.intranet.prod.int.rdu2.redhat.com>
Date: Thu, 23 Jan 2014 21:27:48 +0100
X-Google-Sender-Auth: MQNQAq7z74u64-KDj6hFCgX0KTY
Message-ID: <CAMuHMdVRR4gKrR4Fx1ZMjZTRQXsP0o2o_ySv_gSzjjoM6ZtmCw@mail.gmail.com>
Subject: Re: [PATCH 5/10] atyfb: remove resolution limit 1600
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 7:19 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> The card works fine in 1980x1080 resolution. Therefore, there is no need

1920x1080?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
