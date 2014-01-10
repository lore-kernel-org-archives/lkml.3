Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbaAJRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:09:56 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61055 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaAJRJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:09:53 -0500
MIME-Version: 1.0
In-Reply-To: <52D01E9C.2030302@codethink.co.uk>
References: <1389366360-7238-1-git-send-email-ben.dooks@codethink.co.uk>
	<CAMuHMdWSxxgq6dkng_RkJVPyPjODjs9G9Fn_J0GCG9M+RjNzfQ@mail.gmail.com>
	<52D01E9C.2030302@codethink.co.uk>
Date: Fri, 10 Jan 2014 18:09:52 +0100
X-Google-Sender-Auth: 0wc05Z1xYOKplZvJnuRRNnfmU4Y
Message-ID: <CAMuHMdUYkwtdQmTQBQ99i+ubezajxjSRND5SX-tdiJwZ3BZaxw@mail.gmail.com>
Subject: Re: [PATCH] power: fixup clock_ops
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 5:23 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> On 10/01/14 15:59, Geert Uytterhoeven wrote:
>> On Fri, Jan 10, 2014 at 4:06 PM, Ben Dooks <ben.dooks@codethink.co.uk>
>> wrote:
>>>
>>> On the Renesas Lager board, this causes numerous warnings of the
>>> following
>>> and even worse the clock system will not enable clocks, causing drivers
>>> that are in development to fail to work:
>>
>>
>> Did you see a message like
>>
>>      rcar_thermal e61f0000.thermal: thermal sensor was broken
>>
>> on Lager?
>
> rcar_thermal e61f0000.thermal: 1 sensor probed

Good. So it's working.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
