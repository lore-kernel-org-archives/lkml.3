Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3HWHo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:44:27 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50497 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3HWHo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:44:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-bUFP3Rr+yBkSgP7mm12dx4oHAvuZgswf1eTkhkdBdaA@mail.gmail.com>
References: <CAPgLHd-bUFP3Rr+yBkSgP7mm12dx4oHAvuZgswf1eTkhkdBdaA@mail.gmail.com>
Date: Fri, 23 Aug 2013 16:44:25 +0900
Message-ID: <CAKYAXd_f_Fo9a5mSTcG5=89u9wbgm3umGHGLGPcnwc7uiYVduQ@mail.gmail.com>
Subject: Re: [PATCH -next] f2fs: fix error return code in init_f2fs_fs()
From: Namjae Jeon <linkinjeon@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: jaegeuk.kim@samsung.com, namjae.jeon@samsung.com,
        yongjun_wei@trendmicro.com.cn, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/23, Wei Yongjun <weiyj.lk@gmail.com>:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -ENOMEM in the kset create and add error handling
> case instead of 0, as done elsewhere in this function.
>
> Introduced by commit b59d0bae6ca30c496f298881616258f9cde0d9c6.
> (f2fs: add sysfs support for controlling the gc_thread)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Namjae Jeon <namjae.jeon@samsung.com>
