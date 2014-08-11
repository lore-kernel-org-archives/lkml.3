Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaHKJb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:31:29 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:36435 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaHKJb2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Mon, 11 Aug 2014 05:31:28 -0400
Message-Id: <53E8A98A020000780002B059@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 11 Aug 2014 10:31:22 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andy Lutomirski" <luto@amacapital.net>
Cc: "Kees Cook" <keescook@chromium.org>, "Will Drewry" <wad@chromium.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Denys Vlasenko" <vda.linux@googlemail.com>, "X86 ML" <x86@kernel.org>,
        "Alexei Starovoitov" <ast@plumgrid.com>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete
 "struct pt_regs"
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
 <20140801231929.GB26491@localhost.localdomain>
 <CAK1hOcNXdBwd4KZi1V2dLMtRdusvNLPZwTKwYvnpvz3PRnsM+Q@mail.gmail.com>
 <20140811004559.GA2656@lerouge>
 <53E89DA3020000780002B00B@mail.emea.novell.com>
 <CALCETrXmSOmy55r4Ww2tc4MwtywwsWED_oP+dwBS1gTBja2yuA@mail.gmail.com>
In-Reply-To: <CALCETrXmSOmy55r4Ww2tc4MwtywwsWED_oP+dwBS1gTBja2yuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.08.14 at 11:07, <luto@amacapital.net> wrote:
> How does one test the entry CFI annotations?  The best that I know of
> is to single-step through using gdb attached to qemu and see whether
> backtraces seem to work.

Or have the kernel generate a backtrace from a suitable location and
check that the backtrace is correct (of course provided you have Dwarf
stack unwinding support in your kernel).

Jan

