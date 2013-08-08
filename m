Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900Ab3HHHPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:15:34 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48330 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab3HHHPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <1375945532-15766-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1375945532-15766-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Thu, 8 Aug 2013 16:15:32 +0900
Message-ID: <CAKYAXd8E+Sc9hPXU7_DwRCLnBDCAtcHR4Woy13gL6km27sWJJA@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix a build failure due to missing the kobject header
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/8, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> This patch should resolve the following error reported by kbuild test
> robot.
>
> All error/warnings:
>
>    In file included from fs/f2fs/dir.c:13:0:
>    >> fs/f2fs/f2fs.h:435:17: error: field 's_kobj' has incomplete type
>         struct kobject s_kobj;
>
> The failure was caused by missing the kobject header file in dir.c.
> So, this patch move the header file to the right location, f2fs.h.
>
> CC: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Oops.. Looks good :)
Thanks Jaegeuk!

> ---
