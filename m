Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbbAGJAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:00:15 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:46600 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbbAGJAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:00:10 -0500
MIME-Version: 1.0
In-Reply-To: <54ACF45E.4020100@synopsys.com>
References: <1420536979-31149-1-git-send-email-geert@linux-m68k.org>
	<54ACF45E.4020100@synopsys.com>
Date: Wed, 7 Jan 2015 10:00:09 +0100
X-Google-Sender-Auth: PBQrDeDmTxmsyiBgGxwYhkL51RQ
Message-ID: <CAMuHMdX69XjUUjjXNNZcT21brszg9vv8Q+1zDY4jhbKeivKUjg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.19-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <michael@ellerman.id.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

On Wed, Jan 7, 2015 at 9:54 AM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>> [1] http://kisskb.ellerman.id.au/kisskb/head/8277/ (255 out of 262 configs)
>> [2] http://kisskb.ellerman.id.au/kisskb/head/8168/ (all 262 configs)
>> [3] http://kisskb.ellerman.id.au/kisskb/head/8257/ (all 262 configs)
>
> How can I get the ARC tools / config added to test setup.
> AFAIKR linux-next already has ARC setup as I got a build failure report from them
> once [1]
>
> [1] https://lkml.org/lkml/2014/9/25/767

That's Günter's service.

Kisskb doesn't build ARC yet. Stephen, Michael?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
