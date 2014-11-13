Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbaKMPM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:12:29 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:63903 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296AbaKMPM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:12:27 -0500
MIME-Version: 1.0
In-Reply-To: <20141113140913.GC18995@amd>
References: <1415644659-2531-1-git-send-email-geert+renesas@glider.be>
	<20141113140913.GC18995@amd>
Date: Thu, 13 Nov 2014 16:12:25 +0100
X-Google-Sender-Auth: NQIPJR6whn34Nx7K1DgjwqAs2I8
Message-ID: <CAMuHMdUAN_CgWcTFz+LrRODHtBkKscG2iy0p=zZfgTJMu6ES9Q@mail.gmail.com>
Subject: Re: [PATCH v2] PM / Domains: Make genpd parameter of
 pm_genpd_present() const
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Thu, Nov 13, 2014 at 3:09 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Acked-by: Pavel Machek <apvel@ucw.cz>

You've got a new email address? ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
