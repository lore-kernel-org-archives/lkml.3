Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3JWQKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:10:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50244 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab3JWQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:10:50 -0400
Date: Wed, 23 Oct 2013 17:10:38 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Alireza Haghdoost <alireza@cs.umn.edu>, linux-kernel@vger.kernel.org,
        Jerry Fredin <jerry.fredin@netapp.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] block/aio: Enable sysfs nomerge control for I/O requests
 in the plug list
Message-ID: <20131023161038.GI14598@kernel.dk>
References: <CAB-428koa_AtGr_sTW0xWZAqNgqmxKkeB5wGBB6QwxKx=qu3uA@mail.gmail.com>
 <x49txg8x9ro.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49txg8x9ro.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23 2013, Jeff Moyer wrote:
> Alireza Haghdoost <alireza@cs.umn.edu> writes:
> 
> > This patch enables the sysfs to control I/O request merge
> > functionality in the plug list. While this control has been
> > implemented for the request queue, it was dismissed in the plug list.
> > Therefore, block layer merges requests together (or attempt to merge)
> > even if the merge capability was disable using sysfs nomerge parameter
> > value 2.
> 
> Yeah, this looks like an oversight.  Your mailer really munged up the
> patch, though.  You should fix that and resend (unless Jens just fixes
> it up manually).  Also, please specify the -p option to diff or just use
> git diff.

I fixed it up, changed the style slightly as well (no point in reading
and checking the plug first). This is what I queued up:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=dfc302d833c46f40b5f775099da00bb0cf0e81ad

-- 
Jens Axboe

