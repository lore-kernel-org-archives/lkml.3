Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3HRIco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:32:44 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54683 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3HRIck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:32:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130727132915.GA3655@free.fr>
References: <alpine.DEB.2.02.1307232209510.32497@ayla.of.borg>
	<alpine.DEB.2.02.1307232210440.32577@ayla.of.borg>
	<20130727132915.GA3655@free.fr>
Date: Sun, 18 Aug 2013 10:32:39 +0200
X-Google-Sender-Auth: 5yzg_hHIedgU-ybOWBrIRyGJytE
Message-ID: <CAMuHMdVrCeZ5YPyocdvPQNQBem0X4DwO-EuygZ40zgVxa=sOMw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.11-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Andrew Veliath <andrewtv@usa.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 3:29 PM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> Sorry to chime in a bit late...
>
> On 2013-07-23 22:20 +0200, Geert Uytterhoeven spake thusly:
>> On Tue, 23 Jul 2013, Geert Uytterhoeven wrote:
>> > JFYI, when comparing v3.11-rc2 to v3.11-rc1[3], the summaries are:
>> >   - build errors: +9/-23
> [--SNIP--]
>> powerpc-randconfig, due to a kconfig issue:
>>
>> Expose SCOM controllers via debugfs (SCOM_DEBUGFS) [N/y] (NEW) aborted!
>> Console input/output is redirected. Run 'make oldconfig' to update configuration
>> .
>> make[3]: *** [silentoldconfig] Error 1
>
> Can you give me instructions on how to reproduce this error?
>
> randconfig now should print the RNF seed, so that's d be nice to have to
> reproduce the error. Also, having the problematic changeset would be
> nice.

http://kisskb.ellerman.id.au/kisskb/buildresult/9148716/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
