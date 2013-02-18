Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3BRLKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:10:18 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:37710 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3BRLKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:10:16 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Maksim Pikhenko <pikhenko@gmail.com>
Subject: Re: [PATCH] :fs :fat Delete unnecessary blank line.
References: <1360781627-9710-1-git-send-email-pikhenko@gmail.com>
Date: Mon, 18 Feb 2013 20:10:14 +0900
In-Reply-To: <1360781627-9710-1-git-send-email-pikhenko@gmail.com> (Maksim
	Pikhenko's message of "Wed, 13 Feb 2013 22:53:47 +0400")
Message-ID: <877gm53mjt.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maksim Pikhenko <pikhenko@gmail.com> writes:

> Fixing a code style issue.
>
> Signed-off-by: Maksim Pikhenko <pikhenko@gmail.com>

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> ---
>  fs/fat/inode.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index f8f4916..1af574b 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -1476,7 +1476,6 @@ out_fail:
>  	kfree(sbi);
>  	return error;
>  }
> -
>  EXPORT_SYMBOL_GPL(fat_fill_super);
>  
>  /*

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
