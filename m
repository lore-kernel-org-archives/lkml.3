Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaDWLOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:14:20 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:55210 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaDWLOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:14:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140423104528.GD30036@e106331-lin.cambridge.arm.com>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
	<1397756521-29387-4-git-send-email-leif.lindholm@linaro.org>
	<CAMuHMdXBNWum7UJ95uT2hwTd1b5C8ebF2LQ4T-A+RS80p7MH=A@mail.gmail.com>
	<20140418125924.GF5904@bivouac.eciton.net>
	<20140422133515.E7A0BC40754@trevor.secretlab.ca>
	<20140423104528.GD30036@e106331-lin.cambridge.arm.com>
Date: Wed, 23 Apr 2014 13:14:07 +0200
X-Google-Sender-Auth: QWJd-GsSQlTOGyK0ITFjqUj1KN4
Message-ID: <CAMuHMdW80dm0smxt84b+qcwPuRkvXpCHxAYyhcLWETWCEQ5Xcg@mail.gmail.com>
Subject: Re: [PATCH 3/3] of: Handle memory@0 node on PPC32 only
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Apr 23, 2014 at 12:45 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> Does anyone have a LongTrail DT to hand, and if so does the root have a
> compatible string? From grepping through the kernel I could only find a
> model string ("IBM,LongTrail").

It's compatible with "prep":

http://users.telenet.be/geertu/Linux/PPC/root.html

Full tree at:

http://users.telenet.be/geertu/Linux/PPC/DeviceTree.html

Sorry, the HTML version is all I still have.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
