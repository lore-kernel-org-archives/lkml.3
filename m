Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaGTLUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 07:20:05 -0400
Received: from gw1.transmode.se ([195.58.98.146]:51447 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbaGTLUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 07:20:04 -0400
In-Reply-To: <CAFLxGvyAzUwMqi5vAGzoUoP6J4m+6FGC-J4=zKG2ZGguTgO8cg@mail.gmail.com>
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se>	<87lhrpayl4.fsf@igel.home>
	<OF152BAB0C.4FB2E7A9-ONC1257D1B.0031887F-C1257D1B.0031B248@transmode.se>	<87fvhwxps6.fsf@igel.home> <CAFLxGvyAzUwMqi5vAGzoUoP6J4m+6FGC-J4=zKG2ZGguTgO8cg@mail.gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@linux-m68k.org>
MIME-Version: 1.0
Subject: Re: ls -l /proc/1/exe -> Permission denied
X-KeepSent: CEE18EFA:1A4893C0-C1257D1B:003DFC8D;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OFCEE18EFA.1A4893C0-ONC1257D1B.003DFC8D-C1257D1B.003E4142@transmode.se>
Date: Sun, 20 Jul 2014 13:19:58 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 20/07/2014 13:19:58,
	Serialize complete at 20/07/2014 13:19:58
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard.weinberger@gmail.com> wrote on 2014/07/20 
13:06:30:
> 
> On Sun, Jul 20, 2014 at 12:55 PM, Andreas Schwab <schwab@linux-m68k.org> 
wrote:
> > Joakim Tjernlund <joakim.tjernlund@transmode.se> writes:
> >
> >> Andreas Schwab <schwab@linux-m68k.org> wrote on 2014/07/19 22:21:59:
> >>>
> >>> Joakim Tjernlund <joakim.tjernlund@transmode.se> writes:
> >>>
> >>> > Trying to real /proc/<pid>/exe I noticed I could not read links 
not
> >>> > belonging to my user such as:
> >>> > jocke >  ls -l /proc/1/exe
> >>> >              ls: cannot read symbolic link /proc/1/exe: Permission
> >> denied
> >>> >
> >>> > Is this expected?
> >>>
> >>> Yes.  This information is considered private.
> >>
> >> I don't understand why though.
> >
> > It would allow bypassing access restrictions.
> 
> Do you have an example?
> I'm asking because an attacker could make any symlink as he wants to.
> A ln -s /etc/shadow lala still does not give me access to shadow...

precisely, I just want to see what it is pointing too.
Also, the links privs are inconsistent with current behaviour:
 lrwxrwxrwx   1 root root 0 Jul 15 19:03 exe

 Jocke
