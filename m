Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761748Ab3DCF7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:59:40 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53534 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761652Ab3DCF7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <1364799360-23145-7-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364799360-23145-7-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 3 Apr 2013 14:59:38 +0900
Message-ID: <CAKYAXd8h+1PdfAaomRbwRvq=WsqjBMEKTE7irxU68xRgVyM6CQ@mail.gmail.com>
Subject: Re: [PATCH 7/9] f2fs: allocate remained free segments in the LFS mode
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> This patch adds a new condition that allocates free segments in the current
> active section even if SSR is needed.
> Otherwise, f2fs cannot allocate remained free segments in the section since
> SSR finds dirty segments only.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks good!
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
