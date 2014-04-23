Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaDWM5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:57:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37139 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaDWM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:57:44 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-d9-5357b8c6396f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
Cc: "'Alessandro Zummo'" <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Haojian Zhuang'" <haojian.zhuang@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398256168-493-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1398256168-493-1-git-send-email-k.kozlowski@samsung.com>
Subject: Re: [PATCH RESEND 1/2] rtc: 88pm860x: Use of_get_child_by_name
Date: Wed, 23 Apr 2014 21:57:42 +0900
Message-id: <000c01cf5ef3$9d482a90$d7d87fb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9e76xsw0Xq6PRVRASSEcaxpMmXngAA6dOA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zfd1jO8KDDTZONrFYcvEqu8Wc9WvY
	LC6fO8xocXnhJVaL1y8MLS7vmsNmsb+zg9Hi5J9eRgcOjz0TT7J53Lm2h83jxIzfLB59W1Yx
	ekyf95PJ4/MmuQC2KC6blNSczLLUIn27BK6MBc/ushdcYK9YsuYcWwPjLLYuRk4OCQETiU8f
	50LZYhIX7q0Hsrk4hASWMUps3bSbFabozLkX7BCJRYwSU67cZYVwfjNKzPr1gRGkik1ATeLL
	l8PsILaIgLHEmplLwUYxC0xjklhx5TlQBwdQh6vEjLmFIDWcAm4S+9vmsYDYwgLuEksbvzOB
	2CwCqhJHd/wHm8krYCtxbvMJNghbUOLH5Htg9cwCWhLrdx5ngrDlJTavecsMMl5CQF3i0V9d
	iBOMJJYtPwdVLiKx78U7RpBzJAT+sku8vvCMFWKXgMS3yYdYIHplJTYdYIZ4WFLi4IobLBOA
	vkOyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCER3beD8eYB60OM
	yUDrJzJLiSbnAxNCXkm8obGZkYWpiamxkbmlGWnCSuK8ix4mBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgzONarZHKMPns54WC76vf79xn9/a27Tq/KXqsB3KdOe02TPsksd/jb8EXk/lX
	5xoKvXxt/fxGrvaqRU4LF9innX9roCZhl9Am/ElBxUP1rq2n4f7DnOe+Tm9mbfj0/YPPcutn
	dUwB0Vu6gi5VnWK5ueiS2xzjGbyPbU4qS18NWHLz8O9nc0PU9iixFGckGmoxFxUnAgB5nYbT
	/gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsVy+t9jAd1jO8KDDV5c0rdYcvEqu8Wc9WvY
	LC6fO8xocXnhJVaL1y8MLS7vmsNmsb+zg9Hi5J9eRgcOjz0TT7J53Lm2h83jxIzfLB59W1Yx
	ekyf95PJ4/MmuQC2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGQue3WUv
	uMBesWTNObYGxllsXYycHBICJhJnzr1gh7DFJC7cWw8U5+IQEljEKDHlyl1WCOc3o8SsXx8Y
	QarYBNQkvnw5DNYhImAssWbmUrAOZoFpTBIrrjwH6uAA6nCVmDG3EKSGU8BNYn/bPBYQW1jA
	XWJp43cmEJtFQFXi6I7/YDN5BWwlzm0+wQZhC0r8mHwPrJ5ZQEti/c7jTBC2vMTmNW+ZQcZL
	CKhLPPqrC3GCkcSy5eegykUk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIEp4tnUjsYVzZYHGIU4GBU4uEtWBkWLMSaWFZcmXuIUYKDWUmEd8mi
	8GAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgemsrySeENjEzMjSyMzCyMTc3PShJXEeQ+0
	WgcKCaQnlqRmp6YWpBbBbGHi4JRqYHTqUHhx9cYdjR28+xwvyb+UTfl5RWfz3pnz43Ys/7yh
	xLvbSurJ46Zf6z9ZOkkvyKt+z9cy60/p31t39vpsLYmYVrzmaY7Rk8VP+t/YHl125FBX991t
	B+Yvy98vtqS0OEatSyBYynHJQwmtXWu3toWUterta9qfPnXi84YGGV09pb+yLJ6TFmxVYinO
	SDTUYi4qTgQAZlVB81sDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2014 9:29 PM, Krzysztof Kozlowski wrote:
> 
> Use of_get_child_by_name to obtain reference to charger node instead of
> of_find_node_by_name which can walk outside of the parent node.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/rtc/rtc-88pm860x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
> index 816504846cdd..fb9e3c63b4ac 100644
> --- a/drivers/rtc/rtc-88pm860x.c
> +++ b/drivers/rtc/rtc-88pm860x.c
> @@ -293,7 +293,7 @@ static int pm860x_rtc_dt_init(struct platform_device *pdev,
>  	int ret;
>  	if (!np)
>  		return -ENODEV;
> -	np = of_find_node_by_name(np, "rtc");
> +	np = of_get_child_by_name(np, "rtc");
>  	if (!np) {
>  		dev_err(&pdev->dev, "failed to find rtc node\n");
>  		return -ENODEV;
> --
> 1.9.1

