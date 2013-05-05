Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab3EELPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 07:15:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59390 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab3EELPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 07:15:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 10/10] af_unix: use freezable blocking calls in read
Date: Sun, 05 May 2013 13:23:30 +0200
Message-ID: <1391819.HieY1Y9pgd@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMbhsRSm74tsqXT7TG1h8L1DoKQV0_wKd3asxvHPR7bttWkxag@mail.gmail.com>
References: <1367458508-9133-1-git-send-email-ccross@android.com> <CAOS58YO2b=zFGUVqrV1dHV6gDouNJpN2Wnwo_D6f5V7G9Wz9Vg@mail.gmail.com> <CAMbhsRSm74tsqXT7TG1h8L1DoKQV0_wKd3asxvHPR7bttWkxag@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 04, 2013 03:23:30 PM Colin Cross wrote:
> On Sat, May 4, 2013 at 1:39 PM, Tejun Heo <tj@kernel.org> wrote:
> > Hello, Rafael.
> >
> > On Sat, May 4, 2013 at 12:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>> Heh, so you are aware of the deadlock possibilities.  Good selection
> >>> of spots.  For all the conversion patches.
> >>>
> >>>  Acked-by: Tejun Heo <tj@kernel.org>
> >>
> >> I wonder if that includes [3/10] (just to get the record straight)?
> >
> > I think we want the lockdep annotations before these go in. I'll
> > review Colin's new series later today.
> 
> Just to make sure the merge order is clear, the two patches I posted
> yesterday to reintroduce the lockdep warning in try_to_freeze()
> (https://lkml.org/lkml/2013/5/3/488) need to be merged first, then I
> will repost this series on top of that one.

OK, thanks for the clarification.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
