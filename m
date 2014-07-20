Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaGTLvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 07:51:37 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46041 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaGTLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 07:51:36 -0400
X-Auth-Info: QtIXhXpp3eS8ugGiRcpy/h2yKGdO/FTM4fBpjz7PvcY=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ls -l /proc/1/exe -> Permission denied
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>
	<87lhrpayl4.fsf@igel.home>
	<OF152BAB0C.4FB2E7A9-ONC1257D1B.0031887F-C1257D1B.0031B248@transmode.se>
	<87fvhwxps6.fsf@igel.home>
	<CAFLxGvyAzUwMqi5vAGzoUoP6J4m+6FGC-J4=zKG2ZGguTgO8cg@mail.gmail.com>
X-Yow: CHUBBY CHECKER just had a CHICKEN SANDWICH in downtown DULUTH!
Date: Sun, 20 Jul 2014 13:51:31 +0200
In-Reply-To: <CAFLxGvyAzUwMqi5vAGzoUoP6J4m+6FGC-J4=zKG2ZGguTgO8cg@mail.gmail.com>
	(Richard Weinberger's message of "Sun, 20 Jul 2014 13:06:30 +0200")
Message-ID: <87bnskxn7g.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard.weinberger@gmail.com> writes:

> On Sun, Jul 20, 2014 at 12:55 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
>> Joakim Tjernlund <joakim.tjernlund@transmode.se> writes:
>>
>>> Andreas Schwab <schwab@linux-m68k.org> wrote on 2014/07/19 22:21:59:
>>>>
>>>> Joakim Tjernlund <joakim.tjernlund@transmode.se> writes:
>>>>
>>>> > Trying to real /proc/<pid>/exe I noticed I could not read links not
>>>> > belonging to my user such as:
>>>> > jocke >  ls -l /proc/1/exe
>>>> >              ls: cannot read symbolic link /proc/1/exe: Permission
>>> denied
>>>> >
>>>> > Is this expected?
>>>>
>>>> Yes.  This information is considered private.
>>>
>>> I don't understand why though.
>>
>> It would allow bypassing access restrictions.
>
> Do you have an example?

proc symlinks are special because they actually resolve to the inode.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
