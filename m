Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbbAGXru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:47:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbbAGXrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:47:48 -0500
Date: Wed, 7 Jan 2015 15:47:48 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.18 00/84] 3.18.2-stable review
Message-ID: <20150107234748.GC19926@kroah.com>
References: <CA+icZUVM6gXZZztku3z2iy78Z-qMULt0qFsbEQva0hWQ5gKUyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVM6gXZZztku3z2iy78Z-qMULt0qFsbEQva0hWQ5gKUyQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 10:06:25AM +0100, Sedat Dilek wrote:
> [ From the original posting in [1] ]
> Hi Greg,
> 
> just testing Linux v3.18.2-rc1.
> 
> I am here in my local Git tree and applying not the big tarball but
> from the stable-queu.git tree.
> 
> $ cd linux-git
> 
> $ for i in $( cat ../stable-queue-git/queue-3.18/series ) ; do echo [
> $i ] ;  git am ../stable-queue-git/queue-3.18/${i} ; done
> 
> Unfortunately, there is missing a patch to bump the version in the Makefile.
> 
> Is there something speaking against to put your changes to Makefile as
> a patch into queue-3.18?

I have never done that in the 8+ years of stable kernels, so it would be
a change in my workflow, sorry.

> >From your original posting in [1]
> ...
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 3.18.2-rc1
> 
> Filipe Manana <fdmanana@suse.com>
> ...
> 
> For me this means to do an extra commit, add tags etc.

Yes, and my scripts do it for me, when creating a -rc release, see the
scripts/quilt-mail script in the stable-queue.git tree if you are
curious as to how it is done.

thanks,

greg k-h
