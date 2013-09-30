Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3I3TDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:03:30 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46970 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3I3TD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:03:28 -0400
MIME-Version: 1.0
In-Reply-To: <5249B8A4.9070905@gmail.com>
References: <20130930145630.GA14672@linux-mips.org>
	<52499E8B.6000702@gmail.com>
	<C9BC92C2-A7F5-4F9A-B001-D1A7F4ADEA5A@caviumnetworks.com>
	<5249B8A4.9070905@gmail.com>
Date: Mon, 30 Sep 2013 21:03:28 +0200
X-Google-Sender-Auth: vTNrIrX0tFM5HCJKKGLjTJ5wU8o
Message-ID: <CAMuHMdXkb6BH=1QvfHwMN54db9mP64KnCgoAj3aXida7-6OtPA@mail.gmail.com>
Subject: Re: Issue with BUG() in asm-gemeric/bug.h if CONFIG_BUG=n
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        John Crispin <blogic@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 7:45 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>> What about using __builtin_unreachable when we can but turn off warnings
>> and use do{}while(0) when __builtin_unreachable does not exist?  This seems
>> the both worlds.  Newer compilers produce better code with unreachable
>> anyways.
>>
>
> Simply not true.
>
> do{}while(0) is a NOP it is no more useful than an ';' statement.  It
> doesn't serve as a magic uninitialized variable hiding mechanism.

You missed the "turn off warnings" part of the "and".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
