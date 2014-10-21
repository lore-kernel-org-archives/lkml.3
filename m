Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbaJUQlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:41:39 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43618 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbaJUQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:41:38 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1413909661.30379.10.camel@hadess.net>
Subject: Re: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sergey <sergey@elementaryos.org>,
        Ryan Lortie <desrt@desrt.ca>
Date: Tue, 21 Oct 2014 18:41:01 +0200
In-Reply-To: <CAA7pwKODrr7g=u75ALujrVHq5cXNsAf=QtGVCh+rKCrqd7UKUg@mail.gmail.com>
References: <E1XgbTy-00072R-N3@feisty.vs19.net>
	 <CAA7pwKODrr7g=u75ALujrVHq5cXNsAf=QtGVCh+rKCrqd7UKUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 17:48 +0200, Patrik Lundquist wrote:
> Bastien Nocera wrote:
> > I've posted this list at:
> > https://wiki.gnome.org/BastienNocera/KernelWishlist
> 
> I think what you want from epoll_wait() can be done with timerfd.

Ryan added that one to the Wiki, so CC:ing him. And he tells me:
"
It's true, but I don't want to have to do a separate call to setup my
timerfd every time I enter the kernel to sleep.
Nor do I particularly care to have a separate fd for every maincontext.
epoll in general suffers from being _way_ too chatty about the syscalls
that you have to do.
"

Cheers

