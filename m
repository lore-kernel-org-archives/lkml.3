Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaKQXJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:09:20 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45352 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaKQXJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:09:16 -0500
MIME-Version: 1.0
In-Reply-To: <20141117212110.GF344@x4>
References: <20141116090743.GA19172@gmail.com>
	<20141117074247.GB340@x4>
	<20141117082724.GA344@x4>
	<20141117135854.GA15076@gmail.com>
	<CAGXu5j+mHoKpb2aNyxZWEWCOLRS=QeJXZxjU7YHDVcM3uuXZUQ@mail.gmail.com>
	<20141117212110.GF344@x4>
Date: Mon, 17 Nov 2014 15:09:15 -0800
X-Google-Sender-Auth: GEpft7-llzxS66lqg2Np0erTmik
Message-ID: <CAGXu5jJfhsPh99QGT4zSqQ25nC-nm2V+3Y0BZ93aF2OSuhUB=Q@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
From: Kees Cook <keescook@chromium.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ingo Molnar <mingo@kernel.org>, Junjie Mao <eternal.n08@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 1:21 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2014.11.17 at 13:02 -0800, Kees Cook wrote:
>>
>> Eek, well, the warning worked, at least (".bss and .brk lack common
>> file offset") since that was kind of an assumption in the script I
>> wanted to make sure we'd catch if it wasn't true.
>
> It depends on the linker being used. gold (my default) triggers the issue,
> ld.bfd is fine.

Ah-ha! Thanks, that did it for me. I've reproduced it and will get a
solution designed shortly.

-Kees

-- 
Kees Cook
Chrome OS Security
