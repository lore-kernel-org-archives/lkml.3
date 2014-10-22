Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaJVPRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:17:12 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:61852 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaJVPRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:17:08 -0400
MIME-Version: 1.0
In-Reply-To: <1909016.A6gXeHnn7V@avalon>
References: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
	<1413970709-26607-4-git-send-email-geert+renesas@glider.be>
	<1909016.A6gXeHnn7V@avalon>
Date: Wed, 22 Oct 2014 17:17:06 +0200
X-Google-Sender-Auth: a5Pe71mLtrpVtojoHWydvS3YJ6I
Message-ID: <CAMuHMdUDTk=V=07aTt4YmkcXLWLMwS58_+g15BkQ=Gh9Q7Oibw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: shmobile: armadillo800eva dts: Enable TMU0
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 4:58 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Wednesday 22 October 2014 11:38:29 Geert Uytterhoeven wrote:
>> ch0 will be used for clock events and for periodic clock events,
>> ch1 will be used as clock source.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Simon has posted the same change as "[PATCH v2 20/30] ARM: shmobile:
> armadillo800eva-reference: Initialise TMU device using DT". You might want to
> credit him.

Bummer, didn't look hard enough...

Simon: what's the reason these hadn't been applied yet?
Likewise for r8a7778.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
