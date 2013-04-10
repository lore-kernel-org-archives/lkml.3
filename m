Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936220Ab3DJMOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:14:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53387 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935141Ab3DJMOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:14:14 -0400
Date: Wed, 10 Apr 2013 14:13:50 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Jan Kara <jack@suse.cz>
Cc: Jongman Heo <jongman.heo@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Phillip Susi <psusi@ubuntu.com>
Subject: Re: [3.9-rc5 regression, BISECTED] INFO: task umount:29671 blocked
 for more than 120 seconds
Message-ID: <20130410121350.GB12244@kernel.dk>
References: <20130410120639.GC11686@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410120639.GC11686@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10 2013, Jan Kara wrote:
> Axboe <axboe@kernel.dk>, Phillip Susi <psusi@ubuntu.com>
> Bcc: 
> Subject: Re: [3.9-rc5 regression, BISECTED] INFO: task umount:29671 blocked
>  for more than 120 seconds
> Reply-To: 
> In-Reply-To: <12072206.85601365230982200.JavaMail.weblogic@epml02>
> 
>   Hello,
> 
> On Sat 06-04-13 06:49:42, Jongman Heo wrote:
> > Once I reported this issue (on 1st Apr), and have just done git bisect.
> > 
> > I hit kernel hang with 3.9-rc5, during unmount (the device was mounted via loop device, in case it matters).
>   This is known problem and I think already fixed. BTW, it's good to CC
> author of the patch and the relevant maintainer when you bisected the
> problem to a particular patch.

Yep it is, revert went into Linus -git yesterday. And agree on CC'ing
the patch author and maintainer, it's the best way to ensure that it
gets the proper attention it deserves.

-- 
Jens Axboe

