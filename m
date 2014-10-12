Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaJLMbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 08:31:19 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42083 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaJLMbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 08:31:15 -0400
X-Greylist: delayed 1779 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2014 08:31:15 EDT
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fat: remove redundant sys_tz declaration
References: <1412009379-9189-1-git-send-email-fabf@skynet.be>
Date: Sun, 12 Oct 2014 21:01:29 +0900
In-Reply-To: <1412009379-9189-1-git-send-email-fabf@skynet.be> (Fabian
	Frederick's message of "Mon, 29 Sep 2014 18:49:39 +0200")
Message-ID: <87lhol7azq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabian Frederick <fabf@skynet.be> writes:

> sys_tz is already declared extern struct in include/linux/time.h
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/fat/misc.c | 2 --
>  1 file changed, 2 deletions(-)

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> diff --git a/fs/fat/misc.c b/fs/fat/misc.c
> index 628e22a..d8da2d2 100644
> --- a/fs/fat/misc.c
> +++ b/fs/fat/misc.c
> @@ -164,8 +164,6 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
>  	return 0;
>  }
>  
> -extern struct timezone sys_tz;
> -
>  /*
>   * The epoch of FAT timestamp is 1980.
>   *     :  bits :     value

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
