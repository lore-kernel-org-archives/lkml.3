Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab3FVTvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 15:51:36 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58455 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3FVTvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 15:51:32 -0400
MIME-Version: 1.0
In-Reply-To: <1371572663-10846-1-git-send-email-g.portay@overkiz.com>
References: <1371572663-10846-1-git-send-email-g.portay@overkiz.com>
Date: Sat, 22 Jun 2013 21:51:31 +0200
X-Google-Sender-Auth: 2FESIEMwqDET46RjLyAVhl9uXOk
Message-ID: <CAMuHMdUGbP3yAAhadN-itDBHFZ+=R7RCeMdMGFvDSEgJgXGSNg@mail.gmail.com>
Subject: Re: [RFC PATCH] led: add Cycle LED trigger.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?B?R2HDq2wgUE9SVEFZ?= <g.portay@overkiz.com>
Cc: Rob Landley <rob@landley.net>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-leds@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 6:24 PM, Gaël PORTAY <g.portay@overkiz.com> wrote:
> For example, it is easy to customize the cycle to mock up the rhythm of human
> breathing which is a nice cycle to tell the user the system is doing something.

Like, ledtrig-heartbeat?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
