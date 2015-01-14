Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbbANWub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:50:31 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:45457 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbbANWu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:50:29 -0500
MIME-Version: 1.0
In-Reply-To: <20150114224115.GF6902@pd.tnic>
References: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
 <CAK1hOcMZKpcLVWffv_L9DoaK5-V2qSHkm3N2=mo8wKZfEMLyWA@mail.gmail.com>
 <CALCETrXBKnXzhhtvv5o_jAQnShrBJ1v8jCn7dXhDdiOOcZAp+g@mail.gmail.com> <20150114224115.GF6902@pd.tnic>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 14 Jan 2015 23:50:08 +0100
Message-ID: <CAK1hOcN5eAyEjG_Ax1Bwi+PDK9Ak+9R0H2LMTY+OYLkEnprwdw@mail.gmail.com>
Subject: Re: [PATCH 01/11] x86: entry_64.S: always allocate complete "struct pt_regs"
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 11:41 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Jan 14, 2015 at 02:29:39PM -0800, Andy Lutomirski wrote:
>> I need to go through Linus' and everyone else's comments on that to
>> figure out what to do first.
>
> Right, we want to take it slow and be conservative here - entry_XX.S is
> not a joke.

No problem - I just wanted you to know what I have in the pipeline.

There are four more optimization patches on top of this patchset,
I'm not posting those because I see they will definitely collide
with some of Andy's patches.
