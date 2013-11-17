Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3KQSC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 13:02:28 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49978 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3KQSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 13:02:23 -0500
MIME-Version: 1.0
In-Reply-To: <20131117160126.GG27323@pd.tnic>
References: <52888F6D.6000802@gmail.com>
	<20131117132531.GB27696@pd.tnic>
	<5288E5BF.2020608@gmail.com>
	<20131117160126.GG27323@pd.tnic>
Date: Sun, 17 Nov 2013 19:02:21 +0100
Message-ID: <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
From: Francis Moreau <francis.moro@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 5:01 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Nov 17, 2013 at 04:50:23PM +0100, Francis Moreau wrote:
>> AFAIK, the kernel has 2 simple patches on top of the vanilla one.
>> They're both are trivial and can't be related to this issue.
>>
>> You can have look to them here:
>> https://wiki.archlinux.org/index.php/Kernels#Official_packages
>
> Ok.
>
>> Assuming that I'm running an upstream kernel, it's almost 100%
>> reproductible.
>
> Is there any chance you can catch the whole oops, esp. keep the Code:
> line complete?

Sorry I haven't taken the original picture large enough, and getting
this kernel panic is pretty hard since the kernel usually displays the
black screen.

>
> Also, can you do:
>
> $ objdump -d vmlinux | less
>
> then search for 'call_timer_fn' and paste the whole function somewhere.

I can't find any traces of this function in the dump...

>
> Also, can you catch a full dmesg and upload that somewhere too?

http://paste.debian.net/66294/

Thanks.
-- 
Francis
