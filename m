Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbaGNTND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:13:03 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56572 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaGNTMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:12:53 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: David Miller <davem@davemloft.net>
Cc: miklos@szeredi.hu, dhowells@redhat.com, hooanon05g@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: new mailing list for union/overlay filesystems?
Date: Mon, 14 Jul 2014 21:12:35 +0200
Message-ID: <66941674.g6WvxqVh4a@xrated>
User-Agent: KMail/4.13.2 (Linux/3.11.10-17-desktop; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140625.155459.559484835637033294.davem@davemloft.net>
References: <CAJfpegshQmihBb3xGQOcz3ua_b0v1ce=Xknmg7HzF=HqBe8i5Q@mail.gmail.com> <20140625.155459.559484835637033294.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uuepHbOorJ0X7u9TvMWvSR7lmX6OQKygbswf32m6nzp
 FMvs8jCcpJhaF9UnNTK0sbU/x+EaP+b1ddRj1Cu37216/xnFLY
 3lbDHzvCnvyABfIUgaeQLJcqzhHqO5gyfEu0EDotnpDw6MPDjH
 21LdmeykWW2MeZUKgIvnXOYuqBJLxPBjgD+Vj+VAuPb69gjqbN
 HszUPIZyk95NEck9hl3h+5ookEp2l0Jlek2rFPqRgjL3A8xvYR
 3X7cS04XM4Rt5ThQUnoSHF1O1Nimb17FagdlLO//JLJAtivQhn
 6tBmwXHMQHxkhNtf/l3/ezj43CaYSCO4bLM2Ntj25idzorK9A=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David,

sorry for the late chime in.

On Mittwoch, 25. Juni 2014 15:54:59 David Miller wrote:
> From: Miklos Szeredi <miklos@szeredi.hu>
> Date: Thu, 19 Jun 2014 14:36:50 +0200
> 
> > There's interest in having a mailing list specifically for "union
> > filesystem" like solutions (currently active projects are aufs,
> > union-mounts and overlayfs).
> > 
> > Would it be possible to create one on vger for this purpose?
> 
> I've created linux-unionfs@vger.kernel.org

While this is a great move, it's also a little unfortunate, since it is the 
name of exactly one layered filesystem solution out of 4 existing ones 
(ignoring vaporware).

A neutral name would have been linux-layeredfs, and as long as nobody objects, 
I kindly ask you to rename it (as in creating such a ml, and silently phase 
out this one..). Given that 13 people are subscribed by now, that's hopefully 
acceptable for all participants.

BTW, all solutions organize the fs join by layering them. ;)

A layered fs user since about a decade,
Pete

