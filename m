Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3KYAkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 19:40:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31536 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3KYAkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 19:40:15 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f666d0000048b0-4c-52929c6ca1eb
Content-transfer-encoding: 8BIT
Message-id: <52929C64.2090903@samsung.com>
Date: Mon, 25 Nov 2013 09:40:04 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Austin Boyle <boyle.austin@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] max17042: Fix build errors caused by missing REGMAP_I2C
 config
References: <20131124214149.cf1b6444d6e43d637ea7e34b@gmail.com>
In-reply-to: <20131124214149.cf1b6444d6e43d637ea7e34b@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkQDdnzqQgg2MLFS0ObtW0OPBtEavF
	5V1z2Cw+9x5htLjduILNgdVjQv8nRo+ds+6ye/RtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
	7fZ1bAWvBCrOPFRqYLzN18XIySEhYCLxaG8XC4QtJnHh3nq2LkYuDiGBpYwSN67NYoUpWn5o
	DyNEYhGjxNpN+8ASvAKCEj8m3wPq5uBgFpCXOHIpGyTMLKAuMWneImaI+teMEtvnrmGHqNeS
	OH/zHiOIzSKgKvHzyjkwm01ATuJt0zcwW1QgTOLqhONgF4kIaEq8XT6VCWQQs0Ano8TzvdvZ
	QBLCAqESD/bMB2sQErCXWLR9DpjNKeAg8bvjOhvE1fvYJU5+rIdYJiDxbfIhsEMlBGQlNh1g
	hiiRlDi44gbLBEaxWUjemYXwziwk7yxgZF7FKJpakFxQnJReZKpXnJhbXJqXrpecn7uJERhT
	p/89m7iD8f4B60OMyUAbJzJLiSbnA2MyryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJQUIC6Ykl
	qdmpqQWpRfFFpTmpxYcYmTg4pRoYcyXvPn+XWrjXQvHV/O8f+K5Lc4gobmE+OtU02H6+bd6e
	juz+Pwx/KqX37tG853HQatq8+MLpU9S7XfdeSDhqt3DmWZtpqQX+/+5tO9C22+Gyy8+1V46L
	lUt1nyt/ZvPt363rx9saM5hv3Du4eCGr0KTH3PpixelXmrKYzu5/pnjqrEfjvO+q/5RYijMS
	DbWYi4oTAQqvWFa/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG7OnElBBj+XS1sc3KppceDbIlaL
	y7vmsFl87j3CaHG7cQWbA6vHhP5PjB47Z91l9+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygvUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwhrGjNvt69gKXglUnHmo1MB4m6+LkZNDQsBEYvmhPYwQtpjE
	hXvr2boYuTiEBBYxSqzdtI8VJMErICjxY/I9li5GDg5mAXmJI5eyQcLMAuoSk+YtYoaof80o
	sX3uGnaIei2J8zfvgQ1lEVCV+HnlHJjNJiAn8bbpG5gtKhAmcXXCcRYQW0RAU+Lt8qlMIIOY
	BToZJZ7v3c4GkhAWCJV4sGc+WIOQgL3Eou1zwGxOAQeJ3x3X2SYwCsxCct8shPtmIblvASPz
	KkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgmH0mtYNxZYPFIUYBDkYlHl6LyklBQqyJZcWV
	uYcYJTiYlUR499QBhXhTEiurUovy44tKc1KLDzEmA303kVlKNDkfmE7ySuINjU3MjCyNzA0t
	jIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGxv6gnxWKqqdSZ2ld7xL8tU+OZ2pZ0
	zMxA6k1ax/Ple6fMjN6TzbP3p8ce5Tc/K4++3bn22IWiuqM2DmFXi7YyTjJwk5a/dC754RY2
	L2uN1uWrzfNbJZqsEtVNddnzVTVC3Jomz91r6T+LNeNymrlMV8lpsfcmVtcEr8v+M3/7e6u5
	SNq7A5xKLMUZiYZazEXFiQCEQW6hHQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 11월 24일 19:41, Austin Boyle wrote:

> max17042 now uses regmap interface but does not enable config option. This patch fixes the following build errors:
> 
> drivers/power/max17042_battery.c:661:15: error: variable ‘max17042_regmap_config’ has initializer but incomplete type
> drivers/power/max17042_battery.c:662:2: error: unknown field ‘reg_bits’ specified in initializer
> drivers/power/max17042_battery.c:662:2: warning: excess elements in struct initializer
> drivers/power/max17042_battery.c:662:2: warning: (near initialization for ‘max17042_regmap_config’)
> drivers/power/max17042_battery.c:663:2: error: unknown field ‘val_bits’ specified in initializer
> drivers/power/max17042_battery.c:663:2: warning: excess elements in struct initializer
> drivers/power/max17042_battery.c:663:2: warning: (near initialization for ‘max17042_regmap_config’)
> drivers/power/max17042_battery.c:664:2: error: unknown field ‘val_format_endian’ specified in initializer
> drivers/power/max17042_battery.c:664:23: error: ‘REGMAP_ENDIAN_NATIVE’ undeclared here (not in a function)
> drivers/power/max17042_battery.c:664:2: warning: excess elements in struct initializer
> drivers/power/max17042_battery.c:664:2: warning: (near initialization for ‘max17042_regmap_config’)
> drivers/power/max17042_battery.c: In function ‘max17042_probe’:
> drivers/power/max17042_battery.c:684:2: error: implicit declaration of function ‘devm_regmap_init_i2c’
> 
> Signed-off-by: Austin Boyle <boyle.austin@gmail.com>
> ---
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 5e2054a..85ad58c 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -196,6 +196,7 @@ config BATTERY_MAX17040
>  config BATTERY_MAX17042
>  	tristate "Maxim MAX17042/17047/17050/8997/8966 Fuel Gauge"
>  	depends on I2C
> +	select REGMAP_I2C
>  	help
>  	  MAX17042 is fuel-gauge systems for lithium-ion (Li+) batteries
>  	  in handheld and portable equipment. The MAX17042 is configured
> 


Sorry, It's my fault. Thanks.

Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
