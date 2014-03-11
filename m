Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaCKRo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:44:26 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37997 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbaCKRoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:44:22 -0400
MIME-Version: 1.0
In-Reply-To: <2274545.CyQ67zvVqo@avalon>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
	<1802214.NxZUiJcWLG@avalon>
	<CAMuHMdVOUuFsObEag_MwUT_jaqfOHMEcUScrkbaTEitmyJr+NQ@mail.gmail.com>
	<2274545.CyQ67zvVqo@avalon>
Date: Tue, 11 Mar 2014 18:44:21 +0100
X-Google-Sender-Auth: NSpH7ScAb8LfARZK2d44Q3scDDo
Message-ID: <CAMuHMdXEOygh0--niiLcXFgnRNPi_b0EGPKVBg2Q6Ws01YmNjw@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi: sh-msiof: Convert to spi core auto_runtime_pm framework
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, Mar 11, 2014 at 5:32 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Tuesday 11 March 2014 17:23:37 Geert Uytterhoeven wrote:
>> On Tue, Mar 11, 2014 at 4:55 PM, Laurent Pinchart wrote:
>> > Does this require drivers/sh/pm_runtime.c to be compiled in ?
>>
>> Let's check...
>>
>> My koelsch-legacy kernel has drivers/sh/pm_runtime.c compiled in.
>> My koelsch-reference kernel hasn't.
>>
>> However, under the -reference kernel many MSTP clocks (incl. MSIOF)
>> seem to be enabled all the time, while under -legacy they are enabled and
>> disabled on demand.
>
> Is PM_RUNTIME enabled in both cases ?

Yes it is.

> There's something fishy in there that we should try to fix without too further
> much delay. Ben Dooks has pointed out the problem a couple of months ago, but
> the discussion on the mailing list just died.

Indeed. I'll look into it next week, unless someone beats me to it.

Note that I dropped Ben's patch to include drivers/sh, as I can't boot into
userspace with it.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
