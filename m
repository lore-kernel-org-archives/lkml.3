Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3KDB6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 20:58:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15606 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3KDB6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 20:58:20 -0500
X-AuditID: cbfee68f-b7f836d000001b39-ed-5276ff3b30b7
Message-id: <5276FF3C.9050304@samsung.com>
Date: Mon, 04 Nov 2013 10:58:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] mfd: max77693: Fix up bug of wrong interrupt number
References: <1381367155-4888-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1381367155-4888-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWyRsSkUNf6f1mQwczPGhbXvzxntTjb9Ibd
	4v7Xo4wWl3fNYbM43c3qwOpx59oeNo95JwM9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+PP
	y3WsBV84KjZf/sfewLiFvYuRk0NCwETi9pOnrBC2mMSFe+vZQGwhgaWMEj23c7sYOcBqmrp5
	IMKLGCWaXtV0MXIB2a8YJXr3zGQBSfAKaEms730CZrMIqEr0n5kONp8NKL7/xQ2wmaICYRIr
	p1+BqheU+DH5HpgtIqAhMfPvFUYQm1kgS+L3y0VgvcICHhLXZ51gh1jsIjFh1yl2kHs4BVwl
	/jU7QJTrSOxvncYGYctLbF7zlhnkNgmBdewSN3+uYYa4R0Di2+RDLBC/yEpsOsAM8a6kxMEV
	N1gmMIrNQnLRLCRjZyEZu4CReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYDyd/vesfwfj
	3QPWhxiTgVZOZJYSTc4HxmNeSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQW
	xReV5qQWH2Jk4uCUamAs2XZKQGKXbO7dnHTXpT36zpm8pRsqUy7Za99bu+ODR6THWjmjZJUX
	/0sn7WfPMvTeMy10h51fubH8+uQ5dTGbFVzjre7td2uXUJE/a9rLsUvXPa3Az/fNXuOnmic2
	+/DLcJ1mttxaoPP43PbXErMSl4tkbvJKW9ozNetlX1fIs28brXLPz1NiKc5INNRiLipOBAAw
	CiIOvQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgK71/7Igg69LlSyuf3nOanG26Q27
	xf2vRxktLu+aw2ZxupvVgdXjzrU9bB7zTgZ69G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhDWPGn5frWAu+cFRsvvyPvYFxC3sXIweHhICJRFM3TxcjJ5Ap
	JnHh3no2EFtIYBGjRNOrmi5GLiD7FaNE756ZLCAJXgEtifW9T8BsFgFVif4z09lBbDag+P4X
	N8CaRQXCJFZOvwJVLyjxY/I9MFtEQENi5t8rjCA2s0CWxO+Xi8B6hQU8JK7POsEOsdhFYsKu
	U2C3cQq4SvxrdoAo15HY3zqNDcKWl9i85i3zBEaBWUg2zEJSNgtJ2QJG5lWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwfH6TGoH48oGi0OMAhyMSjy8EpfLgoRYE8uKK3MPMUpwMCuJ8Dqf
	AwrxpiRWVqUW5ccXleakFh9iTAYGwERmKdHkfGAqySuJNzQ2MTOyNDI3tDAyNidNWEmc90Cr
	daCQQHpiSWp2ampBahHMFiYOTqkGxompHM3maoxK3XUns18462n7zly86fGGrX+V9LWrSlv8
	w0T446/nWk27n9nK0nzx9H6rWbVyrlxyxbkT43jTnTfP/Df11+Wao5NTdmp9lZj3OLZNWclZ
	XmiihZbnt4/LpOdkWi9qW/7vzp19nnf+n2l4+Zzz+oX6/atOTuBuEGnbZXLrXb7gbCWW4oxE
	Qy3mouJEAMlzUfobAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!

Thanks,
Chanwoo Choi

On 10/10/2013 10:05 AM, Chanwoo Choi wrote:
> The max77693 MFD device use irq domain method which has hardware interrupt number
> and virtual interrupt number getting through irq domain mapping. This patch
> use hardware interrupt number instead of virtual interrupt number to get
> struct irq_data.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max77693-irq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/max77693-irq.c b/drivers/mfd/max77693-irq.c
> index 1029d01..66b58fe 100644
> --- a/drivers/mfd/max77693-irq.c
> +++ b/drivers/mfd/max77693-irq.c
> @@ -128,7 +128,8 @@ static void max77693_irq_sync_unlock(struct irq_data *data)
>  static const inline struct max77693_irq_data *
>  irq_to_max77693_irq(struct max77693_dev *max77693, int irq)
>  {
> -	return &max77693_irqs[irq];
> +	struct irq_data *data = irq_get_irq_data(irq);
> +	return &max77693_irqs[data->hwirq];
>  }
>  
>  static void max77693_irq_mask(struct irq_data *data)
> 

