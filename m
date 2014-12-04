Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaLDJBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:01:38 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45734 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaLDJBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:01:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141204035758.GA6346@verge.net.au>
References: <3463511.sXIeyHdjYI@vostro.rjw.lan>
	<20141204035758.GA6346@verge.net.au>
Date: Thu, 4 Dec 2014 10:01:34 +0100
X-Google-Sender-Auth: 2I1clTuslSLlUpt9GtOS40UkPDw
Message-ID: <CAMuHMdVG2ZR4X4pYSAZYP12x+oMfCEd_7ciuHqBjGQqSumNYzQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: sh / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 4:58 AM, Simon Horman <horms@verge.net.au> wrote:
> On Thu, Dec 04, 2014 at 02:24:22AM +0100, Rafael J. Wysocki wrote:
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
>> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
>> depending on CONFIG_PM_RUNTIME may now be changed to depend on
>> CONFIG_PM.
>>
>> Replace CONFIG_PM_RUNTIME with CONFIG_PM in drivers/sh/pm_runtime.c.
>>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> ---
>>
>> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
>> PM_SLEEP is selected) which is only in linux-next at the moment (via the
>> linux-pm tree).
>>
>> Please let me know if it is OK to take this one into linux-pm.
>
> Hi Rafael,
>
> That is fine by me if it is fine by Geert.
>
> Acked-by: Simon Horman <horms+renesas@verge.net.au>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
