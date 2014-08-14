Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaHNJeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 05:34:17 -0400
Received: from mout.gmx.net ([212.227.15.15]:52621 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaHNJeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 05:34:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140813215742.GA7908@kroah.com>
References: <53EBDF31.7010204@nvidia.com> <20140813215742.GA7908@kroah.com>
From: Mattias Nissler <mattias.nissler@gmx.de>
Date: Thu, 14 Aug 2014 11:33:53 +0200
Message-ID: <CAERLvmRXozQEa2kU=Uo3osGnZuLa-3nZV2-mFNDOiWk5vy2NOg@mail.gmail.com>
Subject: Re: debugfs_create_{u,x,s}{8,16,32,64}
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matt Longnecker <mlongnecker@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-Provags-ID: V03:K0:rAIkCo3cUx4C8xUTcbXVX4ewXjDTBG5Dshc02ZqJWGt2663H4aT
 MCG7YWdWGpCbWo46ogkh5AprP+T8LMPKmkw8t1FdhwGTCidN9esrEQ2Q4yoervyL47KTz0o
 bN/7f3fsj0qoIm9C0DKdCMfKEql0qdaJWo6Z2u3+C46J5fBAs6mikuwin3xCYs0beTs6xZO
 BdpSV/fthFzcB4K/EsX/Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 11:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Aug 13, 2014 at 02:57:05PM -0700, Matt Longnecker wrote:
> > Greg,
> >
> > Back in December 2007 Mattias Nissler proposed a patch defining
> > debugfs_create_s32 and friends. In it he reworked the already existent u and
> > x versions. The subject of Mattias's mail was "[PATCH] debugfs: Revamp
> > debugfs_create_{u,x,s}{8,16,32,64} to support signed integers".
> >
> > As I'm writing a new driver related to thermal management, I'm finding the
> > absence of debugfs_create_s32 to be a stumbling block. I see at least two
> > other folks who have stumbled on the absence of debugfs_create_s32 in the
> > past few years.
> >
> > Why didn't we merge Mattias's patch?
>
> I can't remember why I didn't merge a patch from last week, let alone
> from 2007, are you crazy?  :)

Needless to say, I don't remember details either. It might just have
been a case of not adding further debugfs API as long as there's
little demand to justify the addition. The latter may have changed in
the last 7 years (Matt hints at other potential consumers?), but I
personally can't tell as I haven't done any kernel work in more recent
times.

>
>
> > Would you entertain a similar patch today?
>
> I always entertain all patches, you never need to ask if you are allowed
> to send a patch, that's like asking "Am I allowed to ask a question?"...
>
> greg k-h
