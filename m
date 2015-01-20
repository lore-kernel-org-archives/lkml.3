Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbbATGQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:16:20 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:60590 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbATGQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:16:19 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1501200350230.28301@eddie.linux-mips.org>
References: <1421723901-32303-1-git-send-email-paul.gortmaker@windriver.com>
	<1421723901-32303-4-git-send-email-paul.gortmaker@windriver.com>
	<alpine.LFD.2.11.1501200350230.28301@eddie.linux-mips.org>
Date: Tue, 20 Jan 2015 18:16:18 +1200
X-Google-Sender-Auth: xMQj5xOOBR1SjKlPGHDYCoQmapA
Message-ID: <CA+55aFzN2PvWJ6g1Vbe-_oODyX7EiSeDhw5SD=wJeyENnHX41A@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: drop support for 1995 era EISA based platforms
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 4:05 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
>
>  Well, I'd like to keep my x86 box up and alive, to support EISA FDDI
> equipment I maintain if nothing else -- which in particular means the
> current head version of Linux, not some ancient branch.

So if we actually have a user, and it works, then no, we're not
removing EISA support. It's not like it hurts us or is in some way
fundamentally broken, like the old i386 code was (i386 kernel page
fault semantics really were broken, and the lack of some instructions
made it more painful to maintain than needed - not like EISA at all,
which is just a pure add-on on the side).

              Linus
