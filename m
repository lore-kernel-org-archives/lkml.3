Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3FEUMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:12:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35868 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab3FEUMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:12:37 -0400
USER-AGENT: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514
 Thunderbird/17.0.6
X-ENIGMAIL-VERSION: 1.5.1
MIME-Version: 1.0
Message-ID: <51AF9B6C.1030006@oracle.com>
Date: Wed, 5 Jun 2013 13:11:24 -0700 (PDT)
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jfs: neatening
References: <cover.1370388945.git.joe@perches.com>
In-Reply-To: <cover.1370388945.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 06:39 PM, Joe Perches wrote:
> The second patch is speculative and maybe not necessary.
> 
> Is a 3KB reduction in object size when embedded and !CONFIG_PRINTK worth it?

I'm pushing the first patch to linux-next. I haven't made up my mind
about the second. I don't really consider jfs to be the filesystem of
choice for a small embedded system. Maybe something like a dvr, but then
it wouldn't be a big factor.

Thanks
Shagggy

> Joe Perches (2):
>   jfs: Update jfs_error
>   jfs: Reduce object size when CONFIG_PRINTK=n
> 
>  fs/jfs/jfs_dmap.c       | 70 +++++++++++++++++++------------------------------
>  fs/jfs/jfs_dtree.c      | 37 +++++++++++++-------------
>  fs/jfs/jfs_extent.c     |  2 +-
>  fs/jfs/jfs_imap.c       | 69 ++++++++++++++++++++----------------------------
>  fs/jfs/jfs_metapage.c   |  5 ++--
>  fs/jfs/jfs_superblock.h | 17 +++++++++++-
>  fs/jfs/jfs_txnmgr.c     |  2 +-
>  fs/jfs/jfs_xtree.c      | 62 +++++++++++++++++++++----------------------
>  fs/jfs/namei.c          |  2 +-
>  fs/jfs/resize.c         |  2 +-
>  fs/jfs/super.c          | 24 ++++++++++-------
>  fs/jfs/xattr.c          |  4 +--
>  12 files changed, 142 insertions(+), 154 deletions(-)
> 
