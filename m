Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3C0Oev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:34:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab3C0Oet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:34:49 -0400
Date: Wed, 27 Mar 2013 15:34:47 +0100
From: Jan Kara <jack@suse.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] fsfreeze: moving from uniterruptible to killable
Message-ID: <20130327143447.GB1771@quack.suse.cz>
References: <514EC323.7050002@gmail.com>
 <20130326211520.GF2082@quack.suse.cz>
 <CANGUGtD9BNQO9pvO+yeKHc0qojk61fKYDgKm8kfWzu8pCk=YJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANGUGtD9BNQO9pvO+yeKHc0qojk61fKYDgKm8kfWzu8pCk=YJw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-03-13 12:39:10, Marco Stornelli wrote:
> 2013/3/26 Jan Kara <jack@suse.cz>:
> > On Sun 24-03-13 10:10:59, Marco Stornelli wrote:
> >> When a fs is frozen, a process can hang because we wait in
> >> uniterruptible state. We give the user the possibility to kill the process.
> >   Yes, but it needs slightly more work as you probably know... (bailing out
> > properly when the signal arrives).
> >
> >                                                                 Honza
> >
> 
> Of course, indeed, it was only an RFC to start a discussion, not a
> patch :) The point was: is this kind of change a behaviour that can
> break user-space in some way? IMHO no, but I'd like to have a
> discussion about that before to start coding. What do you think?
  Killable wait is almost always safe WRT to userspace breakage. In this
case I cannot see how it could matter. That's why I agree it's a good thing
to do.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
