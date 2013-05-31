Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3EaGWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:22:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48089 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3EaGW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:22:26 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-c0-51a841a02f27
From: Jingoo Han <jg1.han@samsung.com>
To: "'Yijing Wang'" <wangyijing@huawei.com>,
        "'David S. Miller'" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, "'Hanjun Guo'" <guohanjun@huawei.com>,
        "'Jiang Liu'" <liuj97@gmail.com>,
        "'Stanislaw Gruszka'" <sgruszka@redhat.com>,
        "'John W. Linville'" <linville@tuxdriver.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <1369980332-1344-1-git-send-email-wangyijing@huawei.com>
In-reply-to: <1369980332-1344-1-git-send-email-wangyijing@huawei.com>
Subject: Re: [PATCH] net: wireless: iwlegacy: fix build error for il_pm_ops
Date: Fri, 31 May 2013 15:22:24 +0900
Message-id: <000101ce5dc7$374e8190$a5eb84b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQH8cVjvzOrM3s0/rXQx7AAGodIQfJjCqedQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zI92FjisCDTb3M1nMOd/CYnFw50x2
	i8sLL7FaXN41h83izYo77BZbeyQsmo9sZLI4tkDMYvGcMywWd65NY3Lg8tiy8iaTx85Zd9k9
	Wo68ZfV4v+8qm0ffllWMHle+r2b0+LxJLoA9issmJTUnsyy1SN8ugStj2Rqzgj+8FZd6zBsY
	T3N3MXJySAiYSPR/OcMIYYtJXLi3nq2LkYtDSGAZo8TpqWtYYYp+TmqDSixilLj3r58VwvnF
	KDFlzS02kCo2ATWJL18Os4PYIgJhEps+rGcHKWIWmM8kseLpUrAiIQEXiaNfF4GN5RRwlTh/
	dyqYLSzgLbGr9xbYHSwCqhLzOjvB4rwClhI/XrQxQ9iCEj8m32MBsZkFtCTW7zzOBGHLS2xe
	85YZ4lQFiR1nXwPN4QA6wkjidBMbRImIxL4X76De7OSQeHrAF2KVgMS3yYdYQMolBGQlNh2A
	miIpcXDFDZYJjBKzkCyehWTxLCSLZyHZsICRZRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZG
	SKT37mC8fcD6EGMy0PqJzFKiyfnARJFXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBkZn+7KIq1/+eOuln52wcGHK171OiXVeuXqV5sz6fqvC7Z8+
	FOHaslqF4cNv1uYbce1ZhzgaTvd6PuW/ccrSNXD2Ei73W9OmhU204D8osb1f6mqvhnug1iu1
	OV7dPaeY1K9ZmvjZrl2yUTNPzbDWboqVypqqA/zRYQbXOf18j5Ts3jwtb+Pyg0osxRmJhlrM
	RcWJADa2Y7oKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAd0FjisCDTbtsbKYc76FxeLgzpns
	FpcXXmK1uLxrDpvFmxV32C229khYNB/ZyGRxbIGYxeI5Z1gs7lybxuTA5bFl5U0mj52z7rJ7
	tBx5y+rxft9VNo++LasYPa58X83o8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwjrGjGVrzAr+8FZc6jFvYDzN3cXIySEhYCLxc1IbG4QtJnHh3nogm4tDSGARo8S9
	f/2sEM4vRokpa26BVbEJqEl8+XKYHcQWEQiT2PRhPTtIEbPAfCaJFU+XghUJCbhIHP26iBXE
	5hRwlTh/dyqYLSzgLbGr9xYjiM0ioCoxr7MTLM4rYCnx40UbM4QtKPFj8j0WEJtZQEti/c7j
	TBC2vMTmNW+ZIU5VkNhx9jXQHA6gI4wkTjexQZSISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYw
	sqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4kz6R2MK5ssDjEKMDBqMTDeyBleaAQa2JZ
	cWXuIUYJDmYlEd7Oc0Ah3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcmubySeENjEzMjSyMz
	CyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYORVvfSzK4H7hPFy2+kXjPeE1kXe
	Tv9sX6OwKtsiNkeD70XyeiXxKxyCvQ92frL7t+frcYbwiscKF6Ysq/p+tMA7Z57phfSP+fv8
	psrf7BVlqrbmSZ3Ze8En0UDBeO+0yHypsBXzG9gcTrYFzOpPd5lYX1OoO6Wsd/cZ4z9cOzZP
	XvCWpeSKsBJLcUaioRZzUXEiAGa62+NoAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 31, 2013 3:06 PM, Yijing Wang wrote:
> 
> Fix build error for il_pm_ops if CONFIG_PM is set
> but CONFIG_PM_SLEEP is not set.
> 
> ERROR: "il_pm_ops" [drivers/net/wireless/iwlegacy/iwl4965.ko] undefined!
> ERROR: "il_pm_ops" [drivers/net/wireless/iwlegacy/iwl3945.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: Jingoo Han <jg1.han@samsung.com>

It looks good.
As you did, 'struct dev_pm_ops il_pm_ops' should be protected
by CONFIG_PM_SLEEP.

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/net/wireless/iwlegacy/common.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
> index f8246f2..4caaf52 100644
> --- a/drivers/net/wireless/iwlegacy/common.h
> +++ b/drivers/net/wireless/iwlegacy/common.h
> @@ -1832,16 +1832,16 @@ u32 il_usecs_to_beacons(struct il_priv *il, u32 usec, u32 beacon_interval);
>  __le32 il_add_beacon_time(struct il_priv *il, u32 base, u32 addon,
>  			  u32 beacon_interval);
> 
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  extern const struct dev_pm_ops il_pm_ops;
> 
>  #define IL_LEGACY_PM_OPS	(&il_pm_ops)
> 
> -#else /* !CONFIG_PM */
> +#else /* !CONFIG_PM_SLEEP */
> 
>  #define IL_LEGACY_PM_OPS	NULL
> 
> -#endif /* !CONFIG_PM */
> +#endif /* !CONFIG_PM_SLEEP */
> 
>  /*****************************************************
>  *  Error Handling Debugging
> --
> 1.7.1


