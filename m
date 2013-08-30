Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3H3RmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:42:04 -0400
Received: from kanga.kvack.org ([205.233.56.17]:49851 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab3H3RmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:42:03 -0400
Date: Fri, 30 Aug 2013 13:42:01 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Waiman Long <Waiman.Long@hp.com>
Subject: Re: linux-next: build failure after merge of the aio tree
Message-ID: <20130830174201.GM13330@kvack.org>
References: <20130830175509.39d7fbfd96a4e726ba739d26@canb.auug.org.au> <CA+55aFwfaW0zZJ5_5Yhyq7+wickG0A3MPzseZ922fy56dJNAAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwfaW0zZJ5_5Yhyq7+wickG0A3MPzseZ922fy56dJNAAg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 10:38:25AM -0700, Linus Torvalds wrote:
> On Fri, Aug 30, 2013 at 12:55 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > -                       aio_ring_file->f_path.dentry->d_count,
> > +                       aio_ring_file->f_path.dentry->d_lockref.count,
> 
> This is wrong. If you really want the dentry count (which I doubt, I
> don't see why this code would care _even_ just for a debug printout),
> you should use

Agreed -- it was just debugging code from initial development of the code, 
so I just ended up deleting it instead.

		-ben
-- 
"Thought is the essence of where you are now."
