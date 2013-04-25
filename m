Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3DYX5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:57:41 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:37190 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3DYX5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:57:40 -0400
MIME-Version: 1.0
In-Reply-To: <1366887697-24627-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1366887697-24627-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Fri, 26 Apr 2013 08:57:40 +0900
Message-ID: <CAKYAXd-k-=8ZfyGGqdNK7zZ1rmLqL5JySC+gMELQHTuvkxM_=A@mail.gmail.com>
Subject: Re: [PATCH 1/3] f2fs: check nid == 0 in add_free_nid
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> It is more obvious that add_free_nid checks whether the free nid is zero or
> not.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks reasonable to me.
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks~.
