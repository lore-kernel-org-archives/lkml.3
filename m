Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3CRLbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:31:51 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:58231 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3CRLbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:31:49 -0400
MIME-Version: 1.0
In-Reply-To: <1363585482-7630-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1363585482-7630-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Mon, 18 Mar 2013 20:31:48 +0900
Message-ID: <CAKYAXd9cmOymDjpk+rtbDkBm9e+f0NP_GiUOWXyZY3kf3aTPXw@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix to unlock node page when it was truncated
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> If the node page was truncated, its block address became zero.
> This means that we don't need to write the node page, but have to unlock
> NODE_WRITE, decrease the number of dirty node pages, and then unlock_page
> before returning the f2fs_write_node_page with zero.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>
Looks good to me~

Thanks!
