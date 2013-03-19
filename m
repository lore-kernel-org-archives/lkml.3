Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab3CSFSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:18:09 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:51048 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab3CSFSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <1363585889-8286-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1363585889-8286-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Tue, 19 Mar 2013 14:18:06 +0900
Message-ID: <CAKYAXd_Dfy=4nwh9eQgRv2Ku9JtnUyp7mr3JfhjUhGJaFzxvnQ@mail.gmail.com>
Subject: Re: [PATCH] f2fs: should check the node page was truncated first
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Currently, f2fs doesn't reclaim any node pages.
> However, if we found that a node page was truncated by checking its block
> address with zero during f2fs_write_node_page, we should not skip that node
> page and return zero to reclaim it.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks good to me.
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks!
