Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaAQTE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:04:28 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34779 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaAQTET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:04:19 -0500
MIME-Version: 1.0
In-Reply-To: <20140117180304.GB17314@sirena.org.uk>
References: <1389699411-29135-1-git-send-email-geert@linux-m68k.org>
	<20140114125242.GE15567@sirena.org.uk>
	<CAMuHMdVmSUh8yphZ4oPR=QYp5uMS9BXgPRVuwa19S9q7jWxxiQ@mail.gmail.com>
	<20140114134528.GG15567@sirena.org.uk>
	<CAMuHMdXEsNKRxYv8gh5sDzpg_QH2RmrjYhLhCZx0QCcRN+gdOg@mail.gmail.com>
	<20140114145002.GR15567@sirena.org.uk>
	<CAMuHMdVhmtA0ogEqu-jj8Kvii5CwV8qfHn+GzgQ9uFKzH7Ua6w@mail.gmail.com>
	<20140117180304.GB17314@sirena.org.uk>
Date: Fri, 17 Jan 2014 20:04:19 +0100
X-Google-Sender-Auth: NPPheYGyIPoe6ID5Ugf8NGX_Sgg
Message-ID: <CAMuHMdXBvAYEU3z9cV5Es9bt7p2bGYUYbjQ-ki9N3hj_grTdRw@mail.gmail.com>
Subject: Re: [PATCH/RFC] spi: core: Fix logic mismatch in spi_master.set_cs()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 7:03 PM, Mark Brown <broonie@kernel.org> wrote:
>>   2. Make the documentation match the code.
>>       It seems this is what you prefer?
>
> Yes.

Thanks, will do.

-- 
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
