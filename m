Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813AbaGRNtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:49:25 -0400
Received: from gw1.transmode.se ([195.58.98.146]:54575 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030427AbaGRNtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:49:21 -0400
In-Reply-To: <CAFLxGvw6W196E4mcefz_b16iGHSFKF=RP1gx5eLj0U5NSR9SXg@mail.gmail.com>
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se> <CAFLxGvw6W196E4mcefz_b16iGHSFKF=RP1gx5eLj0U5NSR9SXg@mail.gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: ls -l /proc/1/exe -> Permission denied
X-KeepSent: 542E7A59:842197B0-C1257D19:004B7FF4;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF542E7A59.842197B0-ONC1257D19.004B7FF4-C1257D19.004BECA2@transmode.se>
Date: Fri, 18 Jul 2014 15:49:17 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 18/07/2014 15:49:17,
	Serialize complete at 18/07/2014 15:49:17
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard.weinberger@gmail.com> wrote on 2014/07/18 
14:58:30:
> 
> On Thu, Jul 17, 2014 at 1:18 PM, Joakim Tjernlund
> <joakim.tjernlund@transmode.se> wrote:
> > Trying to real /proc/<pid>/exe I noticed I could not read links not
> > belonging to my user such as:
> > jocke >  ls -l /proc/1/exe
> >              ls: cannot read symbolic link /proc/1/exe: Permission 
denied
> >
> > Is this expected?
> 
> Why do you think this is unexpected?

It only shows the full path to the executable, compare with comm which 
shows basename(app).

I have an idea for qemu-user which needs to identify which processes
are running /usr/bin/qemu-<arch> and which are not so it knows how
to munge different /proc/ files.

 Jocke
