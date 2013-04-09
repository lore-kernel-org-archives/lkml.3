Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935383Ab3DIODV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:03:21 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42286 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445Ab3DIODU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:03:20 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130409235941.11eef57a42cb97efec72f037@canb.auug.org.au>
References: <CA+icZUX-RMW=pHzhOumB2_R99BRAf2qGC4n5bzyLqU6pOCMDFw@mail.gmail.com>
	<20130409235941.11eef57a42cb97efec72f037@canb.auug.org.au>
Date: Tue, 9 Apr 2013 16:03:18 +0200
Message-ID: <CA+icZUXEd41BkB=C+52xQfwhR2OECcd6pCPQ4_j=8fnME76eWQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 3:59 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Sedat,
>
> On Tue, 9 Apr 2013 12:56:46 +0200 Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>> This version hangs... I started in rescue-mode and see that udev,
>> premount and init scripts are run.
>> Currently, I have no glue why when what...
>> Lemme see if I get k(g)bd started.
>>
>> Unfortunately, there was a "quiet" boot-param for grub2 here but it's gone.
>> With "text" I don't see more.
>>
>> Maybe, someone has a hint.
>
> This is probably the known problem that Al Viro is looking at.  See "Boot
> hang due to "pipe: fold file_operations instances in one" in
> next-20130408" and  "Re: hangs on boot in 9984d7394618df9" thread on lkml
> and linux-next mailing lists.
>

Yupp, just was reading them, for followers.

http://marc.info/?t=136545603700003&r=1&w=2
http://marc.info/?t=136545773000008&r=1&w=2

If such things are known - can you please mention it in your daily
Linux-Next changelog.
That would have saved me several hours - digging into the issue -
digging into kdb/kgdb.

- Sedat -

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
