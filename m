Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3KVJJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:09:30 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61554 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab3KVJJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:09:17 -0500
MIME-Version: 1.0
In-Reply-To: <20131122015518.GA31921@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
	<8761rl73s7.fsf@xmission.com>
	<20131122015518.GA31921@redhat.com>
Date: Fri, 22 Nov 2013 10:09:17 +0100
X-Google-Sender-Auth: ixDQ9id5yPQ2Q5J_6VZYqYmQWZU
Message-ID: <CAMuHMdUVvhKLBfZo2gBf=FoQxMEM42yzBjYS8r5sVfXgp940ng@mail.gmail.com>
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 2:55 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> Before you are done we need an ELF loader.  bzImage really is very
>> uninteresting.  To the point I am not at all convinced that an in kernel
>> loader should support it.
>
> Hi Eric,
>
> Why ELF case is so interesting. I have not use kexec to boot ELF
> images in years and have not seen others using it too. In fact bzImage
> seems to be the most common kernel image format for x86, most of the distros
> ship and use.
>
> So first I did the loader for the common use case. There is no reason
> that one can't write another loader for ELF images. It just bloats
> the code. Hence I thought that other image loaders can follow slowly. I am
> not sure why do you say that bzImage is uninteresting.

Welcome to the non-x86-centric world ;-)

Looking at kexec-tools, all of arm, cris, i386, ia64, m68k, mips, ppc, ppc64,
s390, sh, and x86_64 support ELF.
Only arm, i386, ppc, ppc64, sh, and x86_64 support zImage.
It's not clear to me what alpha supports (if it supports anything at all?).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
