Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab3B0Mcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 07:32:32 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60037 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab3B0Mcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 07:32:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130226220618.GK32160@fenchurch.internal.datastacks.com>
References: <20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226033156.GA24999@kroah.com>
	<20130226033803.GA30285@srcf.ucam.org>
	<20130226035416.GA1128@kroah.com>
	<20130226040456.GA30717@srcf.ucam.org>
	<20130226041324.GA7241@kroah.com>
	<20130226042338.GA30944@srcf.ucam.org>
	<CA+55aFx9HkRGfMx6pfR2xsTf0vof_yyrT4ks5TzMKoEpS7w=5g@mail.gmail.com>
	<CAMuHMdV4DbX_i6Ye5v7ObR0no-eDhBzqYrsqVtR5PAXQTVSmVQ@mail.gmail.com>
	<20130226220618.GK32160@fenchurch.internal.datastacks.com>
Date: Wed, 27 Feb 2013 13:32:30 +0100
X-Google-Sender-Auth: RUKu5oZiq-0JgfkPuAti50E-Y8Y
Message-ID: <CAMuHMdUQxX+3kSN+UorapS5a3kZaNrBpY1Nch8nLniMU-w9-DA@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Jones <pjones@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 11:06 PM, Peter Jones <pjones@redhat.com> wrote:
> On Tue, Feb 26, 2013 at 10:57:38PM +0100, Geert Uytterhoeven wrote:
>
>> BTW, I assume UEFI checks itself if enrolled hashes have been revoked,
>> so it must phone home to some server? That must be disabled as well.
>
> No.  Quit fearmongering.

Good to know, thanks!

So revocation will only be done by the guest OS?
I.e. if I only boot my own trusted Linux, even if it's signed with the MS key,
the MS key _on my system_ will never be revoked?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
