Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaIPJZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:25:24 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49880 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaIPJZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:25:22 -0400
MIME-Version: 1.0
In-Reply-To: <5417FA0F.1030403@huawei.com>
References: <5417FA0F.1030403@huawei.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 16 Sep 2014 17:24:41 +0800
Message-ID: <CAHz2CGUSkb08futic+OiWz4zZ==zNRsVLR7EfCr5Wt2eeYxgCw@mail.gmail.com>
Subject: Re: [PATCH] Documentation/memory-barriers.txt: match table to its
 comment followed
To: Yao Dongdong <yaodongdong@huawei.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some one has submitted a patch addressing this issue a few days ago.
The patch is now being cooked in the paulk's tree now, IIRC.

Thanks,
Jianyu Zhan


On Tue, Sep 16, 2014 at 4:51 PM, Yao Dongdong <yaodongdong@huawei.com> wrote:
> The table shows CPU2's sequence of events as "x = B; y = A;", but its comment followed
> described as "x = A; y = B;".
>
> Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
> ---
>  Documentation/memory-barriers.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index a4de88f..9a46bbe 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -115,8 +115,8 @@ For example, consider the following sequence of events:
>         CPU 1           CPU 2
>         =============== ===============
>         { A == 1; B == 2 }
> -       A = 3;          x = B;
> -       B = 4;          y = A;
> +       A = 3;          x = A;
> +       B = 4;          y = B;
>
>  The set of accesses as seen by the memory system in the middle can be arranged
>  in 24 different combinations:
> --
> 1.8.0.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
