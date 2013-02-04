Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3BDDW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:22:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:49221 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab3BDDWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:22:25 -0500
Date: Sun, 3 Feb 2013 17:56:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] firmware: Make user-mode helper optional (v5)
Message-ID: <20130204015635.GA19112@kroah.com>
References: <1359627237-7069-1-git-send-email-tiwai@suse.de>
 <20130131161543.GA25700@kroah.com>
 <CACVXFVNvSSmwxLnCnTKyHiUN40dt1GDG2VarEzouqUkqz0rR1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNvSSmwxLnCnTKyHiUN40dt1GDG2VarEzouqUkqz0rR1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 12:17:33AM +0800, Ming Lei wrote:
> On Fri, Feb 1, 2013 at 12:15 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Jan 31, 2013 at 11:13:53AM +0100, Takashi Iwai wrote:
> >> Hi,
> >>
> >> this is a series of revised patches for making the user-mode helper
> >> call in the firmware loader optional.  Hopefully all things settled
> >> down now.
> >>
> >> v4->v5: fix invalid call of usermodehelper_unlock()
> >
> > Yeah!  I was working on doing just this right as you sent this series
> > in.  I'll take your patches instead of mine, you did all of the hard
> > work here, thanks :)
> >
> > Ming, any objection to me taking them?
> 
> No objections, and I have reviewed the patch set and acked them all.

Doh, I missed that, sorry for the noise.

greg k-h
