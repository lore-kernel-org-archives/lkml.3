Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661Ab3D2VNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:13:09 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:36689 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619Ab3D2VNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:13:07 -0400
MIME-Version: 1.0
In-Reply-To: <201304292250.47699.arnd@arndb.de>
References: <20130429162115.GA6893@kroah.com>
	<201304292154.15920.arnd@arndb.de>
	<CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
	<201304292250.47699.arnd@arndb.de>
Date: Mon, 29 Apr 2013 14:13:06 -0700
X-Google-Sender-Auth: 6qEawJV0ckspX2RZ7e1bwXefN0Q
Message-ID: <CA+55aFzxyB375fKXW37e2JBB57VwMw6UWccRwWSGn_zUa0J7SA@mail.gmail.com>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, David Brown <davidb@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 1:50 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Fair enough. Of course the distinction here is not based on what it
> does, but how it gets used.

Even technically, a "bus" generally has a topology. It has addresses,
and it has a protocol.

i2c is a bus. PCI is a bus. And something like SSB is a bus. There is
a protocol, there's device with identity on the bus, there's stuff
going on.

The SBBI driver has neither addresses nor a protocol. It's literally
just an embedded on-chip serial device as far as I can tell. There's
nothing "bus" about it. It's just a hose.

Yeah, yeah, at some point you can call "anything" a bus. I could call
my little two-seater car a "school bus", because it has wheels, it's
even yellow exactly like the school buses around here. And I can put a
child in it. So my little yellow two-seater must be a bus too. It's
all just how you define your words.

But it's a damn big reach. I didn't use to call the serial line
connecting my computer to the modem a "bus". Even if it connected two
devices.

               Linus
