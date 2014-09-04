Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaIDMlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:41:55 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:39247 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaIDMlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:41:53 -0400
MIME-Version: 1.0
In-Reply-To: <1409834323-7171-2-git-send-email-jlayton@primarydata.com>
References: <1409834323-7171-1-git-send-email-jlayton@primarydata.com>
	<1409834323-7171-2-git-send-email-jlayton@primarydata.com>
Date: Thu, 4 Sep 2014 08:41:51 -0400
Message-ID: <CAHQdGtTqG8aW-cte2PW6pVw+OeCXATgr1BZwdhponuWMjzNg8g@mail.gmail.com>
Subject: Re: [PATCH v2 01/17] locks: consolidate "nolease" routines
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Jeff Layton <jlayton@primarydata.com>
Cc: Devel FS Linux <linux-fsdevel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 8:38 AM, Jeff Layton <jlayton@primarydata.com> wrote:
> GFS2 and NFS have setlease routines that always just return -EINVAL.
> Turn that into a generic routine that can live in fs/libfs.c.
>
> Cc: Trond Myklebust <trond.myklebust@primarydata.com>
> Cc: <linux-nfs@vger.kernel.org>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: <cluster-devel@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@primarydata.com>
> ---
>  fs/gfs2/file.c     | 22 +---------------------
>  fs/libfs.c         | 16 ++++++++++++++++
>  fs/nfs/file.c      | 13 +------------
>  fs/nfs/internal.h  |  1 -
>  fs/nfs/nfs4file.c  |  2 +-
>  include/linux/fs.h |  1 +
>  6 files changed, 20 insertions(+), 35 deletions(-)

Acked-by: Trond Myklebust <trond.myklebust@primarydata.com>

-- 
Trond Myklebust

Linux NFS client maintainer, PrimaryData

trond.myklebust@primarydata.com
