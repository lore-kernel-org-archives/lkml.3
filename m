Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3KURnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:43:03 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55885 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KURm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:42:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJVteJuaD0PRMHSR9cVcMJTSNj4wXtYiftG=-pYSR9vsQ@mail.gmail.com>
References: <5283A000.8090007@gmail.com>
	<1384859554-27268-1-git-send-email-geert@linux-m68k.org>
	<20131121122148.1B43DC40A2C@trevor.secretlab.ca>
	<CAMuHMdXfsB_Ewz9sUPZaAjFaQGTGeqMiD8mJ0tCoH1uFLYGoxw@mail.gmail.com>
	<CAL_JsqJVteJuaD0PRMHSR9cVcMJTSNj4wXtYiftG=-pYSR9vsQ@mail.gmail.com>
Date: Thu, 21 Nov 2013 18:42:58 +0100
X-Google-Sender-Auth: A4sKIRKd-jgq-UAy-ZHIAfiBMCQ
Message-ID: <CAMuHMdWYkaLD2h=oet1w+wB+2wePmnpWWMawrBh7o=KAJym5pg@mail.gmail.com>
Subject: Re: [PATCH 1/9] dt: Handle passed/built-in DT selection in early_init_dt_scan()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 6:38 PM, Rob Herring <robherring2@gmail.com> wrote:
> I really don't like saying one arch can have built-in dtb and another
> one can't. Either we allow it or we don't. If this is a bad feature,
> then why did we let multiple arches implement it.

... and did we put it in asm-generic, so now _every_ arch has __dtb_start.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
