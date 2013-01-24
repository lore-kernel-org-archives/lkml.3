Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3AXLxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:53:09 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:60041 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3AXLxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:53:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130124102756.213380@gmx.net>
References: <50FF006C.7070803@gmx.de>
	<CAMuHMdViEAXdm=iYXeejdnxw_Xj_7HF63DcUojwBm-G+UeSeuw@mail.gmail.com>
	<20130124102756.213380@gmx.net>
Date: Thu, 24 Jan 2013 12:52:59 +0100
X-Google-Sender-Auth: 063hbkAxVBZpESkVTEjcqrRDiVM
Message-ID: <CAMuHMdUHs7dz9M6wjJgyTUOGxueUrN6S9b_a7c_Gnd1KmqQPhw@mail.gmail.com>
Subject: Re: [GIT PULL] parisc fixes for v3.8-rc5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, dave.anglin@bell.net, jejb@parisc-linux.org,
        linux-parisc@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Helge,

On Thu, Jan 24, 2013 at 11:27 AM, Helge Deller <deller@gmx.de> wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
>> On Tue, Jan 22, 2013 at 10:11 PM, Helge Deller <deller@gmx.de> wrote:
>> > please consider pulling the following 4 patches for 3.8-rc5 which
>> improve
>> > the stability of the linux kernel on the parisc architecture.
>>
>> I think you forgot https://patchwork.kernel.org/patch/1917351/
>
> I did not scheduled it as bug fix for 3.8, since the HPUX support is broken in the parisc tree anyway.

IC, I didn't know that.

> But I did not forgot your patch either. It's in my local git repository and will go in for kernel 3.9. That's why it's in state "accepted" in patchwork already.
> I hope that's OK for you?

Sure, it's up to you.

It's just one of the three issues preventing you from having a green
parisc-allmodconfig build on http://kisskb.ellerman.id.au/kisskb/matrix/.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
