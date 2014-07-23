Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaGWAwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:52:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64903 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaGWAwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:52:19 -0400
X-AuditID: cbfee68f-b7fef6d000003970-4f-53cf0741d182
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tobias Klauser'" <tklauser@distanz.ch>
Cc: linux-kernel@vger.kernel.org, "'Suman Anna'" <s-anna@ti.com>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1406031223-15759-1-git-send-email-tklauser@distanz.ch>
In-reply-to: <1406031223-15759-1-git-send-email-tklauser@distanz.ch>
Subject: Re: [PATCH] mailbox/omap: Use module_platform_driver
Date: Wed, 23 Jul 2014 09:52:17 +0900
Message-id: <002801cfa610$59eee630$0dccb290$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+lpmaCRf2WlFklQJK+I5qea8StNwAabFhA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ11H9vPBBjsP61pcXniJ1eLyrjls
	Fnt/7WO1OHDgL6PF/iteDqwe375OYvG4cuo0u0ffllWMHsdvbGfy+LxJLoA1issmJTUnsyy1
	SN8ugStj/6IlbAUH+Ct+rbnM0sDYy9vFyMkhIWAi8fT8WUYIW0ziwr31bF2MXBxCAssYJT6s
	u8EGU7Rl/XJGiMQiRolzK1axQji/GSUmzXvMClLFJqAm8eXLYXYQW0RAS2Lm4W4WkCJmgQ5G
	ie4ZX5hAEkICzhIvW1Ywg9icAi4S+4/cBbI5OIQFbCXu3JUACbMIqEqc3PgY7CReoPDTE5ug
	bEGJH5PvsYDYzEDz1+88zgRhy0tsXvMWbIyEgLrEo7+6ECcYSbx+vIMdokREYt+Ld2APSAhc
	Y5dYv/s9E8QuAYlvkw+xQPTKSmw6wAzxsKTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyi
	qQXJBcVJ6UXGesWJucWleel6yfm5mxghkdq/g/HuAetDjMlA6ycyS4km5wMjPa8k3tDYzMjC
	1MTU2Mjc0ow0YSVx3vsPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MBa/2d+65cTsR7Xy
	wdddH3dOPmvw0Vto9+ELsf/mvTgdOf9trtShy+pKKQ909O8embFRqFvswf5Jx+VrthY521o9
	vDC3bcI78wkR5qvKFickX3257mnbzy72bxHBNU92cM9ZoWjA+Zt7PseuY3tbbr/xbXDy6JN6
	uK7Q/vmET8/62bbfct148P0iJZbijERDLeai4kQAgBNXt+oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xgK4j+/lggwU3NS0uL7zEanF51xw2
	i72/9rFaHDjwl9Fi/xUvB1aPb18nsXhcOXWa3aNvyypGj+M3tjN5fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsX/REraCA/wVv9ZcZmlg7OXtYuTkkBAwkdiy
	fjkjhC0mceHeerYuRi4OIYFFjBLnVqxihXB+M0pMmveYFaSKTUBN4suXw+wgtoiAlsTMw90s
	IEXMAh2MEt0zvjCBJIQEnCVetqxgBrE5BVwk9h+5C2RzcAgL2ErcuSsBEmYRUJU4ufEx2GZe
	oPDTE5ugbEGJH5PvsYDYzEDz1+88zgRhy0tsXvMWbIyEgLrEo7+6ECcYSbx+vIMdokREYt+L
	d4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcBp4Jr2D
	cVWDxSFGAQ5GJR7egppzwUKsiWXFlbmHGCU4mJVEeKNbgUK8KYmVValF+fFFpTmpxYcYTYEe
	ncgsJZqcD0xReSXxhsYmZkaWRmYWRibm5krivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGE0P
	tsSaPVm+KsZwRk9AsSF/0t7ZgbllnYKOnx3Y3jzI3MIpdrLvuKV5jdyeXTt3KTdM/uj3vZ+j
	+o7o320OT1Re3UhhuDrvR9WcuSsOdeRnFefo1SyaGpfw4A7PD6m45A+5M92F785dXHr16u9Q
	qYtSR5bvXinvsSZ+zVpxk6bZhb7S0nKthkosxRmJhlrMRcWJAIUGPjgZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 22, 2014 9:14 PM, Tobias Klauser wrote:
> 
> Use the module_platform_driver to omit module init/exit boilerplate code.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/mailbox/mailbox-omap1.c | 13 +------------
>  drivers/mailbox/mailbox-omap2.c | 13 +------------
>  2 files changed, 2 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
> index 9001b76..735aeef 100644
> --- a/drivers/mailbox/mailbox-omap1.c
> +++ b/drivers/mailbox/mailbox-omap1.c
> @@ -184,18 +184,7 @@ static struct platform_driver omap1_mbox_driver = {
>  	},
>  };
> 
> -static int __init omap1_mbox_init(void)
> -{
> -	return platform_driver_register(&omap1_mbox_driver);
> -}
> -
> -static void __exit omap1_mbox_exit(void)
> -{
> -	platform_driver_unregister(&omap1_mbox_driver);
> -}
> -
> -module_init(omap1_mbox_init);
> -module_exit(omap1_mbox_exit);
> +module_platform_driver(omap1_mbox_driver);
> 
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("omap mailbox: omap1 architecture specific functions");
> diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
> index 42d2b89..a9dedf0 100644
> --- a/drivers/mailbox/mailbox-omap2.c
> +++ b/drivers/mailbox/mailbox-omap2.c
> @@ -337,18 +337,7 @@ static struct platform_driver omap2_mbox_driver = {
>  	},
>  };
> 
> -static int __init omap2_mbox_init(void)
> -{
> -	return platform_driver_register(&omap2_mbox_driver);
> -}
> -
> -static void __exit omap2_mbox_exit(void)
> -{
> -	platform_driver_unregister(&omap2_mbox_driver);
> -}
> -
> -module_init(omap2_mbox_init);
> -module_exit(omap2_mbox_exit);
> +module_platform_driver(omap2_mbox_driver);
> 
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("omap mailbox: omap2/3/4 architecture specific functions");
> --
> 2.0.1


