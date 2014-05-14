Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaENNDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:03:37 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54789 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaENNDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:03:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140514100856.5198DC4153D@trevor.secretlab.ca>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com>
	<20140514100856.5198DC4153D@trevor.secretlab.ca>
Date: Wed, 14 May 2014 15:03:35 +0200
X-Google-Sender-Auth: TTdd3SwSLSqdtY4DrXw7qDuRx3I
Message-ID: <CAMuHMdXfNXB7s71+joCpkZrzPCJQFyNv3+bj+=usORRScZsHZQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 12:08 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
>> +config OF_OVERLAY
>> +     bool "OF overlay support"
>> +     depends on OF
>> +     select OF_DYNAMIC
>> +     select OF_DEVICE
>> +     select OF_RESOLVE
>> +     help
>> +       OpenFirmware overlay support. Allows you to modify on runtime the
>> +       live tree using overlays.
>
> Should not be a user-visable option. Drivers using it should select it

Why not? It's up to the (final) user to use it, or not.

> or otherwise cause it to be enabled.

Why should this be driver-specific? Shouldn't this just work with all drivers?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
