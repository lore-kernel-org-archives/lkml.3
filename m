Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3HPAUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 20:20:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3HPAU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 20:20:29 -0400
Date: Thu, 15 Aug 2013 17:22:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jens Frederich <jfrederich@gmail.com>
Cc: devel@driverdev.osuosl.org, Jon Nettleton <jon.nettleton@gmail.com>,
        Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: olpc_dcon: more big endian conformity
Message-ID: <20130816002204.GA16114@kroah.com>
References: <1375650256-12411-1-git-send-email-jfrederich@gmail.com>
 <20130812210720.GA10370@kroah.com>
 <CAF92urqkWhXO0_DiFG5hp4qDXLYEoATrrvOw-JXQvWvHQp3QDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF92urqkWhXO0_DiFG5hp4qDXLYEoATrrvOw-JXQvWvHQp3QDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 09:54:05PM +0200, Jens Frederich wrote:
> On Mon, Aug 12, 2013 at 11:07 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Sun, Aug 04, 2013 at 11:04:16PM +0200, Jens Frederich wrote:
> >> Using an int which is casted to unsigned char as inbuf is messy.
> >> The code won't work on big endian systems.  The patch should fix
> >> this.
> >>
> >> Signed-off-by: Jens Frederich <jfrederich@gmail.com>
> >
> > This patch doesn't apply at all, can you refresh it against my
> > staging-next branch and resend it so that I can apply it?
> >
> 
> Sorry for the duplicated patch 3.  The subject:
> [PATCH] Staging: olpc_dcon: more big endian conformity and
> [PATCH 3/3] Staging: olpc_dcon: more big endian conformity
> is equal for the Google mail client and lands in the same
> thread.  I'd use Mutt.

I do use mutt, and see two copies of this patch sent.

What happened to patch 1/3, I never got that.

thanks,

greg k-h
