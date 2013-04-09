Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936186Ab3DIOLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:11:54 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59573 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762822Ab3DIOLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:11:52 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130409235941.11eef57a42cb97efec72f037@canb.auug.org.au>
References: <CA+icZUX-RMW=pHzhOumB2_R99BRAf2qGC4n5bzyLqU6pOCMDFw@mail.gmail.com>
	<20130409235941.11eef57a42cb97efec72f037@canb.auug.org.au>
Date: Tue, 9 Apr 2013 16:11:50 +0200
Message-ID: <CA+icZUVk-iLtodZi_46qmk410Ei+tW6RR5kV2fx0N8v6neKTPQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
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

[ CC Al Viro ]

Is there a "magic" git-command to revert all commits coming from your
latest vfs-merge (commit c1c04d3667608a630ae0821995b465a523e83fb1)?

2013-04-09 11:36 Stephen Rothwell   │ M─┐ │ │ │ │ │ │         │ 20130405/vfs

After reverting all these commits I would like to pull-in latest
vfs.git#for-next.

Thanks in advance.

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/log/?h=for-next

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
