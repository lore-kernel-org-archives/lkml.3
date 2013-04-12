Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3DLDSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 23:18:21 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:56390 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3DLDSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 23:18:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8FKGg=JFK3_f2PJxNjS5S5OD-+PotHEKLM6pi9C5QJOg@mail.gmail.com>
References: <CAPgLHd8FKGg=JFK3_f2PJxNjS5S5OD-+PotHEKLM6pi9C5QJOg@mail.gmail.com>
Date: Fri, 12 Apr 2013 12:18:19 +0900
Message-ID: <CAKYAXd9tKVrS-=T+6aW2cqwr+hr+_5o23vHZdborfNcmyVzcaQ@mail.gmail.com>
Subject: Re: [PATCH -next] f2fs: fix error return code in f2fs_fill_super()
From: Namjae Jeon <linkinjeon@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: jaegeuk.kim@samsung.com, namjae.jeon@samsung.com,
        yongjun_wei@trendmicro.com.cn, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/12, Wei Yongjun <weiyj.lk@gmail.com>:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.
> Introduce by commit c0d39e(f2fs: fix return values from validate
> superblock)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
