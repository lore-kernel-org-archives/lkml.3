Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbaGTJC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 05:02:57 -0400
Received: from gw1.transmode.se ([195.58.98.146]:63213 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaGTJCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 05:02:55 -0400
In-Reply-To: <87lhrpayl4.fsf@igel.home>
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se> <87lhrpayl4.fsf@igel.home>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: Re: ls -l  /proc/1/exe -> Permission denied
X-KeepSent: 152BAB0C:4FB2E7A9-C1257D1B:0031887F;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF152BAB0C.4FB2E7A9-ONC1257D1B.0031887F-C1257D1B.0031B248@transmode.se>
Date: Sun, 20 Jul 2014 11:02:48 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 20/07/2014 11:02:48,
	Serialize complete at 20/07/2014 11:02:48
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab <schwab@linux-m68k.org> wrote on 2014/07/19 22:21:59:
> 
> Joakim Tjernlund <joakim.tjernlund@transmode.se> writes:
> 
> > Trying to real /proc/<pid>/exe I noticed I could not read links not 
> > belonging to my user such as:
> > jocke >  ls -l /proc/1/exe
> >              ls: cannot read symbolic link /proc/1/exe: Permission 
denied
> >
> > Is this expected?
> 
> Yes.  This information is considered private.

I don't understand why though.
Why have exe in the fist place then?

 Jocke
