Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaJ0N4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:56:21 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:49542 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaJ0N4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:56:18 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414418126.30379.47.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 27 Oct 2014 14:55:26 +0100
In-Reply-To: <5446B3CC.1080904@amacapital.net>
References: <1413881397.30379.7.camel@hadess.net>
	 <5446B3CC.1080904@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 12:28 -0700, Andy Lutomirski wrote:
> On 10/21/2014 01:49 AM, Bastien Nocera wrote:
> > Hey,
> > 
> > GNOME has had discussions with kernel developers in the past, and,
> > fortunately, in some cases we were able to make headway.
> > 
> > There are however a number of items that we still don't have solutions
> > for, items that kernel developers might not realise we'd like to rely
> > on, or don't know that we'd make use of if merged.
> > 
> > I've posted this list at:
> > https://wiki.gnome.org/BastienNocera/KernelWishlist
> > 
> > Let me know on-list or off-list if you have any comments about those, so
> > I can update the list.
> 
> I don't know much about desktop environment infrastructure, but I think
> the kernel probably already has a lot of what's needed for LinuxApps.
> 
> Tools like Sandstorm [1] (shameless plug, but it's a good example here)
> can already sandbox normal-ish programs, and those sandboxes can be
> launched without privilege [2].
> 
> Why is kdbus needed?

Because it sucks less than passing fd's and using home-made protocols on
top of it.

>   Why are overlays better than, say, btrfs
> lightweight copies here?  Also, overlayfs might actually make it for 3.19.

Overlayfs works on more than just btrfs, which is useful to not rely on
a particular filesystem to implement those features.

> As for childfs, I implemented procfs polling a couple years ago, but it
> never went anywhere:
> 
> http://lkml.kernel.org/g/1840e47fc4113af16989a4250d98bed62a9bce53.1354559528.git.luto@amacapital.net
> 
> If that would help, I can try to dust it off and get it in to the kernel.

I'll pass that on to Ryan who requested this feature.

Cheers

