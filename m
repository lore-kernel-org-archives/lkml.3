Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3LALPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 06:15:22 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47229 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3LALPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 06:15:20 -0500
MIME-Version: 1.0
In-Reply-To: <87fvqkpam2.fsf@igel.home>
References: <1382039212-26062-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdUUvzc1eGhJjqye7aOcNQoGgOEfT=TDLQgbef6-0vT=qQ@mail.gmail.com>
	<87fvqkpam2.fsf@igel.home>
Date: Sun, 1 Dec 2013 12:15:19 +0100
X-Google-Sender-Auth: x51Z2lPAzP1793A9RRDWdD3T47M
Message-ID: <CAMuHMdUsEc=webi62QpMasTjRVo2exsxxr204QDhM60MV383Ew@mail.gmail.com>
Subject: Re: [PATCH/RFC] m68k/amiga: Fix specifying multiple debug= parameters
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 8:03 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
>>>   2. Do we want to fix it this way? Alternatives are:
>>>        a. Reject a second debug= parameter by checking for a non-NULL .write()
>>>           method
>>>           => only the first debug console will be used,
>>>        b. Skip console registration in case of a non-NULL .write() method
>>>           => only the last debug console will be used,
>>>   3. Atari has a similar issue, with even more (4) debug consoles.
>
> 2b is backward compatible.

Thanks, good point!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
