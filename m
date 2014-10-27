Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaJ0PMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:12:49 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:39801 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaJ0PMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:12:48 -0400
MIME-Version: 1.0
In-Reply-To: <1414418126.30379.47.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net> <5446B3CC.1080904@amacapital.net>
 <1414418126.30379.47.camel@hadess.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 27 Oct 2014 08:12:26 -0700
Message-ID: <CALCETrWQ5r39aqP+MFZuD__5HiNAc+cDQoghsDSEc9oVsmsyvQ@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
To: Bastien Nocera <hadess@hadess.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 27, 2014 6:56 AM, "Bastien Nocera" <hadess@hadess.net> wrote:
>
> On Tue, 2014-10-21 at 12:28 -0700, Andy Lutomirski wrote:
> > On 10/21/2014 01:49 AM, Bastien Nocera wrote:
> > > Hey,
> > >
> > > GNOME has had discussions with kernel developers in the past, and,
> > > fortunately, in some cases we were able to make headway.
> > >
> > > There are however a number of items that we still don't have solutions
> > > for, items that kernel developers might not realise we'd like to rely
> > > on, or don't know that we'd make use of if merged.
> > >
> > > I've posted this list at:
> > > https://wiki.gnome.org/BastienNocera/KernelWishlist
> > >
> > > Let me know on-list or off-list if you have any comments about those, so
> > > I can update the list.
> >
> > I don't know much about desktop environment infrastructure, but I think
> > the kernel probably already has a lot of what's needed for LinuxApps.
> >
> > Tools like Sandstorm [1] (shameless plug, but it's a good example here)
> > can already sandbox normal-ish programs, and those sandboxes can be
> > launched without privilege [2].
> >
> > Why is kdbus needed?
>
> Because it sucks less than passing fd's and using home-made protocols on
> top of it.

For securely communicating with a container, "it sucks less" is hard
to use as a design criterion.

What's wrong with fds, and how does kdbus solve it?

--Andy
