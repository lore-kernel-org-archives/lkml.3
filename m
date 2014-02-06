Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaBFBzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:55:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11162 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbaBFBzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:55:03 -0500
X-AuditID: cbfee690-b7f266d00000287c-5d-52f2eb76d4c0
Message-id: <52F2EB76.5010908@samsung.com>
Date: Thu, 06 Feb 2014 10:55:02 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 08/18] mfd: max14577: Rename state container to maxim_core
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-9-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1390911522-28209-9-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWyRsSkSLfs9acgg1mfzC2mPnzCZvH6haHF
	2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbNYe+Quu8XtxhVsFqe7WR24PHbOusvusWlVJ5vH
	nWt72DzmnQz02Lyk3qNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyDsy7xlLQxlFx4vQK1gbG
	PWxdjJwcEgImEk/XToGyxSQu3FsPZHNxCAksZZRo/L2VEabo1+ndTBCJ6YwSx54+hnJeMUpM
	3zcRrIpXQEvizvReZhCbRUBVYvbHg0wgNhtQfP+LG2ArRAXCJFZOv8ICUS8o8WPyPTBbRMBQ
	4uDu7WBDmQXuM0l0/T0MlhAW8JM4+bIVbJCQQCujxM3eQBCbU8BDYvM1iDizgI7E/tZpbBC2
	vMTmNW+ZQQZJCLxllzi3upkR4iIBiW+TDwEN5QBKyEpsOsAM8ZqkxMEVN1gmMIrNQnLTLCRj
	ZyEZu4CReRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYJSe/vdswg7GewesDzEmA62cyCwl
	mpwPjPK8knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amAsjXwbEOVzsuop88bUXe2q1pOnHsut0j6R9cBqXaHppO45Zu8vhnNsElrL3xM8SbPuXtze
	o//vdvNP491sdHF51/fZM1saD09qLjs+VeYTg8usd4VBue+rN4QdfJ1ukKwZ9rFVc3P097sp
	Ynpbwh6sap9a26/PunDzyTV7f8Vq/xLe/OtMhkSWEktxRqKhFnNRcSIAwdZFF+gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd2y15+CDC6f0LeY+vAJm8XrF4YW
	Z5vesFvc/3qU0eLblQ4mi02Pr7FaXN41h81i7ZG77Ba3G1ewWZzuZnXg8tg56y67x6ZVnWwe
	d67tYfOYdzLQY/OSeo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjDmHFg3jWWgjaOihOnV7A2MO5h62Lk5JAQMJH4dXo3E4QtJnHh3nqgOBeHkMB0Rolj
	Tx8zQTivGCWm75vICFLFK6AlcWd6LzOIzSKgKjH740Gwbjag+P4XN8CmigqESaycfoUFol5Q
	4sfke2C2iIChxMHd28GGMgvcZ5Lo+nsYLCEs4Cdx8mUr2CAhgVZGiZu9gSA2p4CHxOZrEHFm
	AR2J/a3T2CBseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJEZwCnknvYFzVYHGIUYCDUYmHd8P6T0FCrIllxZW5hxglOJiVRHgvPgcK8aYkVlalFuXH
	F5XmpBYfYkwGBsFEZinR5HxgesoriTc0NjEzsjQyN7QwMjYnTVhJnPdgq3WgkEB6Yklqdmpq
	QWoRzBYmDk6pBka9yj1MCx2kZzr81mQNXbGrX57t13/ncNONzdq7Xh18VXr09oGjbMePLv64
	4Z7EVAeVPj7Pm8mnhTVWK/9ep1X57vDsLf/+Zp1VXdXdyrB1jSnz4S8ly9oCM06uKp+3fOXj
	V9LM+WdkxBaxSSWfF5Rku7kzIaGwIV45tqrWWbWsW828iuu3/G8lluKMREMt5qLiRACJyN3E
	RQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 09:18 PM, Krzysztof Kozlowski wrote:
> This patch continues the preparation for adding support for max77836
> device to existing max14577 driver.
> 
> The patch renames the struct "max14577" state container to "maxim_core".
> This is only a rename-like patch, new code is not added.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/extcon/extcon-max14577.c     |   22 +++++------
>  drivers/mfd/max14577.c               |   68 +++++++++++++++++-----------------
>  drivers/power/max14577_charger.c     |   16 ++++----
>  drivers/regulator/max14577.c         |    6 +--
>  include/linux/mfd/max14577-private.h |    5 ++-
>  5 files changed, 60 insertions(+), 57 deletions(-)
> 

For extcon:
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

For mfd/regulator/charger/extcon of max14577
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi


