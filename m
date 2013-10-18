Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab3JRWoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:44:11 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:65505 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757067Ab3JRWoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:44:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmkGAFO4YVJ5LAy1/2dsb2JhbABagweDTLYghUaBIhd0giUBAQU6HCMQCAMOBgQJJQ8FJQMhE4gFwHAWj0AHhCkDmAiKQ4dFgWaBUig
Date: Sat, 19 Oct 2013 09:44:04 +1100
From: Dave Chinner <david@fromorbit.com>
To: Rich Johnston <rjohnston@sgi.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk,
        mtk.manpages@gmail.com, tytso@mit.edu, adilger.kernel@dilger.ca,
        bpm@sgi.com, elder@kernel.org, hch@infradead.org,
        Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND 4/7] xfsprogs: xfsio: add support
 FALLOC_FL_COLLAPSE_RANGE for fallocate
Message-ID: <20131018224404.GX4446@dastard>
References: <1381090418-2829-1-git-send-email-linkinjeon@gmail.com>
 <52616EC6.7030400@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52616EC6.7030400@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 12:24:22PM -0500, Rich Johnston wrote:
> This has been committed.
> 
> Thanks
> --Rich
> 
> commit e64190f8440286a815060524777b435e06a7b364
> Author: Namjae Jeon <namjae.jeon@samsung.com>
> Date:   Sun Oct 6 20:13:38 2013 +0000
> 
>     [RESEND, 4/7] xfsprogs: xfsio: add support
> FALLOC_FL_COLLAPSE_RANGE for fallocate

Hi Rich,

This isn't ready for being committed into xfsprogs. The kernel code
is still under review, and until we actually have it in a tree to be
merged int eh kernel, we shoul d't be making any userspace changes
at all. Indeed, there's a chance (unlikely, but still there) that
this code may still not end up in the kernel at all...

So, it's probably best right now to revert this patch until we have
the fallocate API support merged into the kernel...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
