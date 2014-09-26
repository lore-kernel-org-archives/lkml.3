Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaIZGZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:25:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56086 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaIZGZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <7heguzbd4z.fsf@deeprootsystems.com>
References: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
	<1410893339-6361-3-git-send-email-geert+renesas@glider.be>
	<7heguzbd4z.fsf@deeprootsystems.com>
Date: Fri, 26 Sep 2014 08:25:26 +0200
X-Google-Sender-Auth: h9-_l4L0qd7k1YrU6R70d7IjHLs
Message-ID: <CAMuHMdVp6MiPb8Dhph=eyTgsnBbQSzEHbA9TOjCDi=7BM8GgTg@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 02/12] PM / Domains: Add DT bindings for PM QoS
 device latencies
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Thu, Sep 25, 2014 at 11:31 PM, Kevin Hilman <khilman@kernel.org> wrote:
> Geert Uytterhoeven <geert+renesas@glider.be> writes:
>> PM QoS device start/stop and save/restore state latencies are more or
>> less properties of the hardware.
>> In legacy code, they're specified from platform code.
>> On DT platforms, their values should come from DT.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>> Should these properties be called "linux,*-latency"?
>
> Hmm, the start/stop latencies are clearly properties of the hardware,
> but the save/restore latencies seem to be a function of the driver.
> e.g., some drivers may keep a shadow copy of their registers in memory
> so the save time is minimized.
>
> I don't have too strong of an opinion on this, but probably the drivers
> should just add their own values to the start/stop latencies to add the
> linux specific overhead.

Thanks. I agree with you on this, so I'll remove the save/restore latencies.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
