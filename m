Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbaEEKGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:06:49 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:42077 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbaEEKGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:06:48 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140505195711.fcce1825483f7a1ce707c2c6@canb.auug.org.au>
References: <20140505171459.3ce28e8e0c4d6b107a66eb97@canb.auug.org.au>
 <CAHO5Pa0D8bxBV98feBt2qk_gb3XdTDcmaa6bD7eQv4UOdjcFrA@mail.gmail.com> <20140505195711.fcce1825483f7a1ce707c2c6@canb.auug.org.au>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 5 May 2014 12:06:27 +0200
Message-ID: <CAKgNAkj4hsTBqfD72ZhoCrHdV4S_68tJEQ_AaE0KWO_cySqeHw@mail.gmail.com>
Subject: Re: linux-next: Tree for May 5
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, May 5, 2014 at 11:57 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Michael,
>
> On Mon, 5 May 2014 10:42:23 +0200 Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>>
>> I don't know what the process is for clearing cruft out of linux-next
>> is, but there's at least one piece of cruft that probably should go:
>
> I usually depend on maintainers to clean up their trees.
>
>> commit d30c01a0611d54926ac860721c933edafcc91905
>> commit 8c013e265a8eca0ada9f1aaa6cd7590698dc7231
>> commit e86263c9d00efb091a5215b9e4063378828d815c
>
> I can't find any of these commits in linux-next or any commits by Andrey
> Vagin <avagin@openvz.org> ...

Okay, must be my problem then. Sorry for the noise. Somehow, I'm not
syncing my linux-next correctly then. (Is the proper way of doing this
documented somewhere?)

> [P.S. Please trim replies to relevant bits ...]

Ah yes--sorry.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
