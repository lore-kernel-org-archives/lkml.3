Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3CRL34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:29:56 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:38219 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3CRL3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:29:54 -0400
MIME-Version: 1.0
In-Reply-To: <1363586046-8693-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1363586046-8693-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Mon, 18 Mar 2013 20:29:53 +0900
Message-ID: <CAKYAXd8Aps4oBDR_v80g_gbBC_EuazbzSjTveX=AN2woUjGWOA@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix to call WRITE_FLUSH at the end of fsync
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> The fsync call should be ended after flushing the in-device caches.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>
Looks good!

Thanks.
