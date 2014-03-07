Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaCGKJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:09:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaCGKJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:09:47 -0500
Subject: Re: [PATCH 0/3] gfs: More logging neatening
From: Steven Whitehouse <swhiteho@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, cluster-devel@redhat.com
In-Reply-To: <cover.1394136338.git.joe@perches.com>
References: <20140306182724.6754407d4c629085d9fc318e@skynet.be>
	 <cover.1394136338.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 07 Mar 2014 10:08:24 +0000
Message-ID: <1394186904.2733.2.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2014-03-06 at 12:10 -0800, Joe Perches wrote:
> Joe Perches (3):
>   gfs2: Use pr_<level> more consistently
>   gfs2: Use fs_<level> more often
>   gfs2: Convert gfs2_lm_withdraw to use fs_err
> 
>  fs/gfs2/dir.c        | 14 ++++----
>  fs/gfs2/glock.c      |  8 +++--
>  fs/gfs2/lock_dlm.c   |  9 +++--
>  fs/gfs2/main.c       |  2 ++
>  fs/gfs2/ops_fstype.c | 25 ++++++-------
>  fs/gfs2/quota.c      | 10 +++---
>  fs/gfs2/rgrp.c       | 24 +++++++------
>  fs/gfs2/super.c      | 16 ++++-----
>  fs/gfs2/sys.c        |  6 ++--
>  fs/gfs2/trans.c      | 19 +++++-----
>  fs/gfs2/util.c       | 99 +++++++++++++++++++++++++---------------------------
>  fs/gfs2/util.h       | 31 ++++++++--------
>  12 files changed, 138 insertions(+), 125 deletions(-)
> 

Thanks for the patches. I've added them to the -nmw tree, and I did spot
the V2 patch of the third one,

Steve.


