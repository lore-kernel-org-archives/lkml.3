Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaBFBxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:53:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10802 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbaBFBxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:53:11 -0500
X-AuditID: cbfee68e-b7f566d000002344-50-52f2eb063407
Message-id: <52F2EB05.2070009@samsung.com>
Date: Thu, 06 Feb 2014 10:53:09 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 07/18] mfd: max14577: Rename and add MAX14577 symbols to
 prepare for max77836
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-8-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1390911522-28209-8-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWyRsSkSJft9acggwfzuS2mPnzCZvH6haHF
	2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbNYe+Quu8XtxhVsFqe7WR24PHbOusvusWlVJ5vH
	nWt72DzmnQz02Lyk3qNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyzl38w1IwiaNiQ+MOpgbG
	XWxdjJwcEgImErsWHGSGsMUkLtxbDxTn4hASWMoo8bp1DxNMUc/XC8wQiemMEl8XPmaHcF4x
	Shw8eYUVpIpXQEtiwoUpYGNZBFQl2ndsArPZgOL7X9wAs0UFwiRWTr/CAlEvKPFj8j0wW0TA
	UOLg7u1g25gF7jNJrDqiA2ILCyRLfDxwAeqkVkaJkzcegTVwCnhILFl5jhmiQUdif+s0Nghb
	XmLzmrdgp0oIvGSXWPv2IjPERQIS3yYfAmrmAErISmw6APWzpMTBFTdYJjCKzUJy0ywkY2ch
	GbuAkXkVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRmCUnv73rG8H480D1ocYk4FWTmSWEk3O
	B0Z5Xkm8obGZkYWpiamxkbmlGWnCSuK8ix4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg
	5K6xCgxlfWp4zeyP2bdbbe9z9xv/mscydYnRlI6/bc2zWOPmP/e5zeoUe/BCAN/k69M28/3V
	eXE1y2NX+acT59OE1+zhFmpLc7B1quhJOyfNuPFUyb5ttbxnRcT1DI+rZhVe92Rb+ulzbkiE
	Wtm6fytKFFqnGL4T1T1i7OQdlBGzJNFWNP+6EktxRqKhFnNRcSIAPFo2HegCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV2215+CDOb8ZbKY+vAJm8XrF4YW
	Z5vesFvc/3qU0eLblQ4mi02Pr7FaXN41h81i7ZG77Ba3G1ewWZzuZnXg8tg56y67x6ZVnWwe
	d67tYfOYdzLQY/OSeo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjDmHHu4h+WgkkcFRsadzA1MO5i62Lk5JAQMJHo+XqBGcIWk7hwbz1QnItDSGA6o8TX
	hY/ZIZxXjBIHT15hBaniFdCSmHBhClg3i4CqRPuOTWA2G1B8/4sbYLaoQJjEyulXWCDqBSV+
	TL4HZosIGEoc3L2dCcRmFrjPJLHqiA6ILSyQLPHxwAWoza2MEidvPAJr4BTwkFiy8hwzRIOO
	xP7WaWwQtrzE5jVvmScwCsxCsmMWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/d
	xAhOAc+kdjCubLA4xCjAwajEw7th/acgIdbEsuLK3EOMEhzMSiK8F58DhXhTEiurUovy44tK
	c1KLDzEmA4NgIrOUaHI+MD3llcQbGpuYGVkamRtaGBmbkyasJM57oNU6UEggPbEkNTs1tSC1
	CGYLEwenVAOjRMuX6QlOenKHireZc7+SebLyP1OvXsUPxYr0BQentKoy7qor1p74r/FFqfeU
	3Xs9njDu7vVXFVr6ZP7hifzBE08pzdS7M60+V2Pqps9bHrw+ovHX3m+bWVe8DLOY2TZPo/9t
	fJt+1UUtqVVwu/r1l8uDDQfy4mx3VIrd5C3jkrtVePud5iVpJZbijERDLeai4kQAKlU+10UD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 09:18 PM, Krzysztof Kozlowski wrote:
> This patch prepares for adding support for max77836 device to existing
> max14577 driver:
> 1. Renames most of symbols and defines prefixed with MAX14577 to MAXIM.
> 2. Adds prefixes (MAXIM or MAX14577) to defines without any MAX* prefix.
> 
> This is only a rename-like patch, new code is not added.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/extcon/extcon-max14577.c     |  105 ++++-----
>  drivers/mfd/max14577.c               |   51 ++---
>  drivers/power/max14577_charger.c     |   81 +++----
>  drivers/regulator/max14577.c         |   44 ++--
>  include/linux/mfd/max14577-private.h |  399 ++++++++++++++++------------------
>  include/linux/mfd/max14577.h         |    2 +-
>  6 files changed, 333 insertions(+), 349 deletions(-)
> 

For extcon:
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

