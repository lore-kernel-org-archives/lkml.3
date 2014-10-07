Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaJGJTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:19:50 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39905 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaJGJTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:19:40 -0400
MIME-Version: 1.0
In-Reply-To: <1412659726-29957-36-git-send-email-linux@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
	<1412659726-29957-36-git-send-email-linux@roeck-us.net>
Date: Tue, 7 Oct 2014 11:19:36 +0200
X-Google-Sender-Auth: H8CqPrWYHuzCKE6AZjzih_WrqS4
Message-ID: <CAMuHMdVZmsjK9FdK0T6mWwrnNc=Xc97B7ynm+QbWUMBCnvQB_g@mail.gmail.com>
Subject: Re: [PATCH 35/44] m68k: Register with kernel poweroff handler
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>,
        driverdevel <devel@driverdev.osuosl.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lguest@lists.ozlabs.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        Cris <linux-cris-kernel@axis.com>, linux-efi@vger.kernel.org,
        "open list:QUALCOMM HEXAGON..." <linux-hexagon@vger.kernel.org>,
        linux-m32r-ja@ml.linux-m32r.org,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>, linux-tegra@vger.kernel.org,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        openipmi-developer@lists.sourceforge.net,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-c6x-dev@linux-c6x.org,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "open list:METAG ARCHITECTURE" <linux-metag@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        xen-devel@lists.xenproject.org, Joshua Thompson <funaho@jurai.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 7:28 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Joshua Thompson <funaho@jurai.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

As someone already mentioned, having #defines instead of hardcoded
numbers for the priorities would be nice.

Apart from that:

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> +       register_poweroff_handler_simple(nf_poweroff, 128);

> +       register_poweroff_handler_simple(mac_poweroff, 128);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
