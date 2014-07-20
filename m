Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaGTWFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 18:05:12 -0400
Received: from gw1.transmode.se ([195.58.98.146]:57894 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaGTWFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 18:05:11 -0400
In-Reply-To: <53CC1FC2.5000806@nod.at>
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>	<87lhrpayl4.fsf@igel.home>
	<OF152BAB0C.4FB2E7A9-ONC1257D1B.0031887F-C1257D1B.0031B248@transmode.se>	<87fvhwxps6.fsf@igel.home>
	<CAFLxGvyAzUwMqi5vAGzoUoP6J4m+6FGC-J4=zKG2ZGguTgO8cg@mail.gmail.com> <87bnskxn7g.fsf@igel.home> <53CBB095.6010705@nod.at> <OF2729CE69.3EF22126-ONC1257D1B.0069427B-C1257D1B.0069CA17@transmode.se> <53CC1FC2.5000806@nod.at>
To: Richard Weinberger <richard@nod.at>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@linux-m68k.org>
MIME-Version: 1.0
Subject: Re: ls -l /proc/1/exe -> Permission denied
X-KeepSent: 09FF18A8:BCFCAEF4-C1257D1B:0078E588;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF09FF18A8.BCFCAEF4-ONC1257D1B.0078E588-C1257D1B.00795152@transmode.se>
Date: Mon, 21 Jul 2014 00:05:06 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 21/07/2014 00:05:06,
	Serialize complete at 21/07/2014 00:05:06
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> wrote on 2014/07/20 22:00:02:
> 
> Am 20.07.2014 21:15, schrieb Joakim Tjernlund:
> > Richard Weinberger <richard@nod.at> wrote on 2014/07/20 14:05:41:
> >>
> >> Am 20.07.2014 13:51, schrieb Andreas Schwab:
> >>> Richard Weinberger <richard.weinberger@gmail.com> writes:
> >>>> Do you have an example?
> >>>
> >>> proc symlinks are special because they actually resolve to the 
inode.
> >>
> >> Ah. If an attacker manages the kernel to follow the symlink he could
> >> indirectly access that file.
> >> Thanks for pointing this out!
> > 
> > That is a big if, I read this as you don't trust the kernels impl.
> > of proc sym links so paper over this with denying all other to read 
> > trivial
> > data such as the exe sym link.
> 
> Feel free to propose a solution for that. :-)

I wish I had one :) Good to know why things are how they are though. I
guess there is a reason why proc symlinks resolve to the inode?

 Jocke
