Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaGTMIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 08:08:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbaGTMIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 08:08:21 -0400
Message-ID: <53CBB095.6010705@nod.at>
Date: Sun, 20 Jul 2014 14:05:41 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ls -l /proc/1/exe -> Permission denied
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>	<87lhrpayl4.fsf@igel.home>	<OF152BAB0C.4FB2E7A9-ONC1257D1B.0031887F-C1257D1B.0031B248@transmode.se>	<87fvhwxps6.fsf@igel.home>	<CAFLxGvyAzUwMqi5vAGzoUoP6J4m+6FGC-J4=zKG2ZGguTgO8cg@mail.gmail.com> <87bnskxn7g.fsf@igel.home>
In-Reply-To: <87bnskxn7g.fsf@igel.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.07.2014 13:51, schrieb Andreas Schwab:
> Richard Weinberger <richard.weinberger@gmail.com> writes:
>> Do you have an example?
> 
> proc symlinks are special because they actually resolve to the inode.

Ah. If an attacker manages the kernel to follow the symlink he could
indirectly access that file.
Thanks for pointing this out!

Thanks,
//richard
