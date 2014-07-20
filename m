Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaGTLGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 07:06:32 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41940 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaGTLGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 07:06:31 -0400
MIME-Version: 1.0
In-Reply-To: <87fvhwxps6.fsf@igel.home>
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>
	<87lhrpayl4.fsf@igel.home>
	<OF152BAB0C.4FB2E7A9-ONC1257D1B.0031887F-C1257D1B.0031B248@transmode.se>
	<87fvhwxps6.fsf@igel.home>
Date: Sun, 20 Jul 2014 13:06:30 +0200
Message-ID: <CAFLxGvyAzUwMqi5vAGzoUoP6J4m+6FGC-J4=zKG2ZGguTgO8cg@mail.gmail.com>
Subject: Re: ls -l /proc/1/exe -> Permission denied
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 12:55 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Joakim Tjernlund <joakim.tjernlund@transmode.se> writes:
>
>> Andreas Schwab <schwab@linux-m68k.org> wrote on 2014/07/19 22:21:59:
>>>
>>> Joakim Tjernlund <joakim.tjernlund@transmode.se> writes:
>>>
>>> > Trying to real /proc/<pid>/exe I noticed I could not read links not
>>> > belonging to my user such as:
>>> > jocke >  ls -l /proc/1/exe
>>> >              ls: cannot read symbolic link /proc/1/exe: Permission
>> denied
>>> >
>>> > Is this expected?
>>>
>>> Yes.  This information is considered private.
>>
>> I don't understand why though.
>
> It would allow bypassing access restrictions.

Do you have an example?
I'm asking because an attacker could make any symlink as he wants to.
A ln -s /etc/shadow lala still does not give me access to shadow...

-- 
Thanks,
//richard
