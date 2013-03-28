Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3C1HY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:24:28 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:47332 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3C1HY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <1364430293-7624-1-git-send-email-gheorghiuandru@gmail.com>
References: <1364430293-7624-1-git-send-email-gheorghiuandru@gmail.com>
Date: Thu, 28 Mar 2013 16:24:26 +0900
Message-ID: <CAKYAXd8dzZK7Kn-_DCDH87E9yYxm-aaaUvPDhxiu6Y5YmjPo9Q@mail.gmail.com>
Subject: Re: [PATCH] fs: f2fs: Use kmemdup
From: Namjae Jeon <linkinjeon@gmail.com>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/28, Alexandru Gheorghiu <gheorghiuandru@gmail.com>:
> Use kmemdup instead of kzalloc and memcpy.
>
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Looks good to me.
Acked-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks~
