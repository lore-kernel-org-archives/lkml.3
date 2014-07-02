Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbaGBQgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:36:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbaGBQgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:36:36 -0400
Date: Wed, 2 Jul 2014 09:36:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
Cc: linux-kernel@vger.kernel.org,
        Thomas =?iso-8859-1?Q?Sch=F6bel-Theuer?= <tst@1und1.de>
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
Message-ID: <20140702163621.GB19349@kroah.com>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
 <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de>
 <20140701223644.GA30330@kroah.com>
 <53B3B283.7050800@schoebel-theuer.de>
 <20140702082400.GB10971@kroah.com>
 <53B3CA91.5000002@schoebel-theuer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B3CA91.5000002@schoebel-theuer.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 11:02:09AM +0200, Thomas Schoebel-Theuer wrote:
> > Maintaining out of tree code is not our problem, sorry. thanks, greg k-h 
> 
> OK, I just noticed that in the meantime many vfs_*() are present now
> which were missing when I started the project on very old kernels (or
> maybe I missed something, sorry for any potential mistakes).
> 
> So I will happily make a new version which has the lowest possible
> footprint in the kernel, but nevertheless is _internally_ portable (just
> for me and the needs of 1&1 users).
> 
> This will incur many changes in many places in the patchset. Is it OK to
> re-submit the _whole_ patchset again after that?

Given that your patchset really isn't even in a reviewable format (you
just add one file per-patch) resending it doesn't bother anyone :)

Hint, you will have to work on a better way to submit this code in a
format that is mergable.  It's a non-trivial task, but going to be
required if you wish for this to ever be accepted.

Best of luck,

greg k-h
