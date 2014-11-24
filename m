Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaKXVnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:43:15 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:63899 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaKXVnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:43:12 -0500
MIME-Version: 1.0
In-Reply-To: <54739F0C.7040802@cogentembedded.com>
References: <1416859808-18503-1-git-send-email-geert+renesas@glider.be>
	<1416859808-18503-3-git-send-email-geert+renesas@glider.be>
	<54739F0C.7040802@cogentembedded.com>
Date: Mon, 24 Nov 2014 22:43:10 +0100
X-Google-Sender-Auth: VAJ7x12HZCP6lcFxw57z6q3BgOQ
Message-ID: <CAMuHMdW3WNywUPwOk=JEX5EURr28xgjojmO8E6tBL+uvkukkJA@mail.gmail.com>
Subject: Re: [PATCH/RFC 2/3] ARM: shmobile: kzm9g-reference dts: Move Ethernet
 node to BSC
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 10:11 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>> Also rename the node's name from "lan9220" to "ethernet", to confirm to
>
>    s/confirm/comply/, you mean?

Sorry, conform.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
