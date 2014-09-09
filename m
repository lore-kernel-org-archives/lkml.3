Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaIIHQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:16:38 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:57359 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbaIIHQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:16:36 -0400
MIME-Version: 1.0
In-Reply-To: <540E313B.8000305@renesas.com>
References: <1410183344-14756-1-git-send-email-geert+renesas@glider.be>
	<1410183344-14756-3-git-send-email-geert+renesas@glider.be>
	<540E313B.8000305@renesas.com>
Date: Tue, 9 Sep 2014 09:16:34 +0200
X-Google-Sender-Auth: p4w-okk-XqN3s2PY9G9O7uaOoSc
Message-ID: <CAMuHMdWRT=ZjXLVtPKJ1ppYLACQhBHJxZRxf6cnGkfC2dLxOOQ@mail.gmail.com>
Subject: Re: [PATCH/RFC 2/5] PM / Domains: Add DT bindings for the R-Mobile
 System Controller
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Khiem Nguyen <khiem.nguyen.xt@renesas.com>
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

Hi Khiem-san,

On Tue, Sep 9, 2014 at 12:44 AM, Khiem Nguyen
<khiem.nguyen.xt@renesas.com> wrote:
>> +      - #address-cells: Must be 1,
>> +      - #address-cells: Must be 0.
>
> Should it be "#size-cells: Must be 0." ?

Yes, obviously. Thanks, will fix.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
