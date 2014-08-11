Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaHKTho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:37:44 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45151 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaHKThn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:37:43 -0400
MIME-Version: 1.0
In-Reply-To: <201408112057.01177.arnd@arndb.de>
References: <1407764228-7904-1-git-send-email-will.deacon@arm.com>
	<CANq1E4Q0gDaJ5XGnkoCQsG8xLh1Q-EBErtEVPpeeZgGj+Nr8dQ@mail.gmail.com>
	<20140811171511.GF8828@arm.com>
	<201408112057.01177.arnd@arndb.de>
Date: Mon, 11 Aug 2014 21:37:41 +0200
X-Google-Sender-Auth: A5jX6MRiU4li3pgXXkgYoQIVcLw
Message-ID: <CAMuHMdWZ30ZKO2ddh8whmw5ThrKZC0wsU+rhgoc8fRZni0Zduw@mail.gmail.com>
Subject: Re: [PATCH 2/2] asm-generic: add memfd_create system call to unistd.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>, David Herrmann <dh.herrmann@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 8:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 11 August 2014, Will Deacon wrote:
>> On Mon, Aug 11, 2014 at 05:54:08PM +0100, David Herrmann wrote:
>> > On Mon, Aug 11, 2014 at 3:37 PM, Will Deacon <will.deacon@arm.com> wrote:
>> > > Commit 9183df25fe7b ("shm: add memfd_create() syscall") added a new
>> > > system call (memfd_create) but didn't update the asm-generic unistd
>> > > header.
>> > >
>> > > This patch adds the new system call to the asm-generic version of
>> > > unistd.h so that it can be used by architectures such as arm64.
>> > >
>> > > Cc: Arnd Bergmann <arnd@arndb.de>
>> > > Cc: David Herrmann <dh.herrmann@gmail.com>
>> > > Signed-off-by: Will Deacon <will.deacon@arm.com>
>> >
>> > Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>>
>> Thanks, David.
>>
>> Arnd: shall I take this via the arm64 tree, or do you already have some
>> asm-generic patches queued?
>
> Please take it for arm64, I don't have any other patches queued at the moment
> and am currently on vacation.

Thanks, I was just going to look into adding it...

BTW, another one sneaked in: kexec_file_load. I say "sneaked", as
scripts/checksyscalls.sh doesn't catch it, due to it being wired up on
amd64 only.

Will, you can please add that one, too, while you're at it?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
