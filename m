Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaEUKgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:36:33 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9416 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaEUKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:36:32 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-12-537c81ac1580
Message-id: <537C81AC.60901@samsung.com>
Date: Wed, 21 May 2014 12:36:28 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Victor Lambret <victor.lambret.ext@parrot.com>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] videobuf2-core: remove duplicated code
References: <1400665723-21695-1-git-send-email-victor.lambret.ext@parrot.com>
In-reply-to: <1400665723-21695-1-git-send-email-victor.lambret.ext@parrot.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xa7prGmuCDbZMsbQ42/SG3eLyrjls
	Fj0btrJaXFwnbzHl7U92i9/7XzI7sHk8/vWSzaOpfx6rR9+WVYwenzfJBbBEcdmkpOZklqUW
	6dslcGXMWjGduWAFR0V7n0cD40u2LkZODgkBE4mjHS3MELaYxIV764HiXBxCAksZJd7ums0O
	4XxilJi+6AoTSBWvgIbE4q0zGUFsFgFVibvrz4DF2QQMJbredoFNFRWIkdj9eSEjRL2gxI/J
	91hABokIvGWUmPbhFFiDsIC1xOrDO1i7GDmANvhKbPhQChLmFPCTeHHiIyuIzSxgJvGoZR0z
	hC0vsXnNW+YJjPyzkIydhaRsFpKyBYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCwvbL
	DsbFx6wOMQpwMCrx8ApcrQ4WYk0sK67MPcQowcGsJMJ7rKImWIg3JbGyKrUoP76oNCe1+BAj
	EwenVAPjpjAeq8rghFUPzH7emnXzwF5r+TP3Tp0/MCugr3WFw47e1eYskx5MKtzqF8itLMyw
	ekFO4bIMteOLAjzkJ7g+bFc/a3tvV61UbOJFmYWitop8esUfwswaV+nvtAp8tt+zVSt1j839
	j+rN7+ZPV1CSOqh9vM68QFbapvPDBdnCN6Gr7kb7+LxWYinOSDTUYi4qTgQARPXNiDkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-05-21 11:48, Victor Lambret wrote:
> Remove duplicated test of buffer presence at streamon
>
> Signed-off-by: Victor Lambret <victor.lambret.ext@parrot.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index f9059bb..b731b66 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2067,10 +2067,6 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>   		return -EINVAL;
>   	}
>   
> -	if (!q->num_buffers) {
> -		dprintk(1, "streamon: no buffers have been allocated\n");
> -		return -EINVAL;
> -	}
>   	if (q->num_buffers < q->min_buffers_needed) {
>   		dprintk(1, "streamon: need at least %u allocated buffers\n",
>   				q->min_buffers_needed);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

