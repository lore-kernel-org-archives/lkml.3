Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaJHVVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:21:55 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:60230 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbaJHVVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:21:54 -0400
MIME-Version: 1.0
In-Reply-To: <20141008160956.7584d303@as>
References: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com>
	<CALCETrUDkHH-FLwq9ZJ0wFeOkQVWUjTh-cJPL4Jq28sHCqhfFA@mail.gmail.com>
	<20141008154659.31f46436@as>
	<5435A4A4.1070101@zytor.com>
	<20141008160956.7584d303@as>
Date: Wed, 8 Oct 2014 17:21:53 -0400
X-Google-Sender-Auth: PmKkHwmr1uZmDCFgef7HD-nPfxA
Message-ID: <CA+5PVA6VuODM1q5AH_-ZeKnzzsmjquY7ykbHow=aWQAXc38bPg@mail.gmail.com>
Subject: Re: vdso_standalone_test_x86.c build failure on Linus' tree
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 5:09 PM, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> On Wed, 08 Oct 2014 13:55:00 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
>
>> On 10/08/2014 01:46 PM, Chuck Ebbert wrote:
>> >
>> > Fedora doesn't cross-compile i686 builds because of problems like
>> > this. It sets up an i386 chroot and runs all native tools inside of
>> > it.
>> >
>>
>> Breaking cross-compilation is not okay, though, regardless of what
>> Fedora does.  It should be okay to, for example, build an i386 kernel on
>> an ARM box.
>>
>
> I think they tried that for a while, and ended up chasing compiler
> and makefile bugs all day. And then there's the software that wants
> to run self-tests as part of its build...

The Fedora kernel package cross builds the other way (ARM on i386)
just fine.  It might build ARM->i386 as well, but that's less useful.
At any rate, Peter is talking about the kernel, not software in
general.

josh
