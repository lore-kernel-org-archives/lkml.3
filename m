Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaGTUAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 16:00:07 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbaGTUAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 16:00:06 -0400
Message-ID: <53CC1FC2.5000806@nod.at>
Date: Sun, 20 Jul 2014 22:00:02 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: ls -l /proc/1/exe -> Permission denied
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>	<87lhrpayl4.fsf@igel.home>	<OF152BAB0C.4FB2E7A9-ONC1257D1B.0031887F-C1257D1B.0031B248@transmode.se>	<87fvhwxps6.fsf@igel.home>	<CAFLxGvyAzUwMqi5vAGzoUoP6J4m+6FGC-J4=zKG2ZGguTgO8cg@mail.gmail.com> <87bnskxn7g.fsf@igel.home> <53CBB095.6010705@nod.at> <OF2729CE69.3EF22126-ONC1257D1B.0069427B-C1257D1B.0069CA17@transmode.se>
In-Reply-To: <OF2729CE69.3EF22126-ONC1257D1B.0069427B-C1257D1B.0069CA17@transmode.se>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.07.2014 21:15, schrieb Joakim Tjernlund:
> Richard Weinberger <richard@nod.at> wrote on 2014/07/20 14:05:41:
>>
>> Am 20.07.2014 13:51, schrieb Andreas Schwab:
>>> Richard Weinberger <richard.weinberger@gmail.com> writes:
>>>> Do you have an example?
>>>
>>> proc symlinks are special because they actually resolve to the inode.
>>
>> Ah. If an attacker manages the kernel to follow the symlink he could
>> indirectly access that file.
>> Thanks for pointing this out!
> 
> That is a big if, I read this as you don't trust the kernels impl.
> of proc sym links so paper over this with denying all other to read 
> trivial
> data such as the exe sym link.

Feel free to propose a solution for that. :-)

Thanks,
//richard
