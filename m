Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761847Ab3DCGAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:00:37 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:62207 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab3DCGAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:00:35 -0400
MIME-Version: 1.0
In-Reply-To: <1364799360-23145-4-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364799360-23145-4-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 3 Apr 2013 15:00:34 +0900
Message-ID: <CAKYAXd_Gy=jJubztntJBtofDwKagFoNK7LffjjoX8qZqzd1b2Q@mail.gmail.com>
Subject: Re: [PATCH 4/9] f2fs: allocate new segment aligned with sections
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> When allocating a new segment under the LFS mode, we should keep the
> section
> boundary.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
You can add
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks!
> ---
