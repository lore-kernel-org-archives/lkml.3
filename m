Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048Ab3JPHlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:41:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933035Ab3JPHlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:41:39 -0400
Date: Wed, 16 Oct 2013 00:42:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Paul Chavent <Paul.Chavent@onera.fr>, linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH] pps : add non blocking option to PPS_FETCH ioctl.
Message-Id: <20131016004227.602493c2.akpm@linux-foundation.org>
In-Reply-To: <20131016072958.GD4285@enneenne.com>
References: <1381495232-12152-1-git-send-email-paul.chavent@onera.fr>
	<20131011124720.bf38f18affa8baf0b009875a@linux-foundation.org>
	<20131015104350.GI4285@enneenne.com>
	<20131015125545.1920ab5453136f3de5f2aa66@linux-foundation.org>
	<525E37BF.4040303@onera.fr>
	<20131016072958.GD4285@enneenne.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013 09:29:58 +0200 Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Wed, Oct 16, 2013 at 08:52:47AM +0200, Paul Chavent wrote:
> > 
> > I would also prefer the separate ioctl. As you said it, it's a bit
> > annoying to switch from blocking mode to non blocking mode if we
> > need both mode. But i was not sure about the preferences of the
> > maintainer : (i) change the api, or (ii) change the behavior with a
> > widely supported interface (O_NONBLOCK).
> 
> As already stated the PPS RFC doesn't use ioctls to manage PPS data so
> we can modify ioctls according our needs!
> 
> In fact we can modify the LinuxPPS wrapper functions to still remain
> RFC compliant. :)

Sure.  I do think the new ioctl is better than O_NONBLOCK.  Are you OK with
that?

> > I'm certainly not the best person to make the final decision, but i
> > would like to help you if you need me (write doc, or change this
> > patch).
> 
> In this scenario I think we can do as Andrew suggests modifying
> LinuxPPS docs accordingly... maybe we can add a new file into
> linux/Documentation/pps directory describing Linux PPS ioctls and how
> they interact with PPS RFC functions.
> 
> Andrew, could this be an acceptable solution?

Sounds great, thanks.
