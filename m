Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbaGQLXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:23:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14888 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042AbaGQLXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:23:31 -0400
X-AuditID: cbfee690-b7fb56d000003439-17-53c7b230bcd6
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org,
        jic23@kernel.org
Subject: [PATCH 2/4 v2] Documentation: dt-bindings: move exynos-adc.txt to more
 iio/adc/
Date: Thu, 17 Jul 2014 16:49:51 +0530
Message-id: <1405595993-16661-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
References: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkVtdg0/FggxsvjC1eHtK0uP7lOavF
	/CPnWC2aF69ns3h15AeTxYOmVUwWSybPZ7WYd+Qdi8XlXXPYLGac38dksWjbf2YHbo/ZDRdZ
	PHbOusvusWlVJ5vH/rlr2D2WvDnE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZ29f2MBc0
	sFe0XnvJ2MDYydbFyMkhIWAi8WDmdiYIW0ziwr31QHEuDiGBpYwSV38/YoEp2nxoFRNEYjqj
	xNFNc6Cq+pkkpq1YyQxSxSZgJnFw0Wp2EFtEIE7iw+V+dpAiZoH9jBKvX+8HSwgLREmcbfwL
	NpZFQFVi2bf7YLt5BVwlGp7MA5rKAbROQWLOJBuQMKeAm8SKNX/AwkJAJTce5IGMlBA4xi5x
	Ze5GJogxAhLfJh9igWiVldh0gBniaEmJgytusExgFF7AyLCKUTS1ILmgOCm9yESvODG3uDQv
	XS85P3cTIzBCTv97NmEH470D1ocYk4HGTWSWEk3OB0ZYXkm8obGZkYWpiamxkbmlGWnCSuK8
	ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwCmjWduUvUb+tcFswiWfR+6aIFcziFxPY
	Tb11t2tdFz4qwSG25aKLCWdBy1w+Bju2SYKaWoqLpD3evhJP2SzYqWqkJ1y306um+aJ3xtnL
	e9yrmxYd27Lvlt7mj1UGu86tT/xpv9G3LGV5rUZbe3Ztn+z7HZWa55rTC+b/1N5Z+LigiEfz
	8hIlluKMREMt5qLiRAA0iuxspgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQV2DTceDDVYt0rF4eUjT4vqX56wW
	84+cY7VoXryezeLVkR9MFg+aVjFZLJk8n9Vi3pF3LBaXd81hs5hxfh+TxaJt/5kduD1mN1xk
	8dg56y67x6ZVnWwe++euYfdY8uYQq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxhzNi+toe5oIG9ovXaS8YGxk62LkZODgkBE4nNh1YxQdhiEhfurQeK
	c3EICUxnlDi6aQ6U088kMW3FSmaQKjYBM4mDi1azg9giAnESHy73s4MUMQvsZ5R4/Xo/WEJY
	IEribONfFhCbRUBVYtm3+2AreAVcJRqezAOaygG0TkFiziQbkDCngJvEijV/wMJCQCU3HuRN
	YORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4/p5J7WBc2WBxiFGAg1GJhzeh9Viw
	EGtiWXFl7iFGCQ5mJRHebV3Hg4V4UxIrq1KL8uOLSnNSiw8xmgLdNJFZSjQ5H5ga8kriDY1N
	zE2NTS1NLEzMLJXEeQ+0WgcKCaQnlqRmp6YWpBbB9DFxcEo1MCqu5Ph45W0hc1OqsHpU7cLN
	c56f2RIa11B6beK3S8+1w6c1Jzo3+ZZPnvqJo/R+eTL/r687JFI4Dj+92da3MMixwbuM3cZe
	4dg6vbO5VlPUf20W2OVe+XPOg5juc8vOF0w3OzVn9X+ZL9231D5d8lq3e/rZwxuXzH+/7M6r
	wzs6lIPP3EuboOSvxFKckWioxVxUnAgAZZkXjdUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DT bindings in exynos-adc.txt applies to the ADC
driver (exynos-adc.c) developed based on IIO framework.

The bindings are more appropriate to be under
Documentation/devicetree/bindings/iio/adc/

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: devicetree@vger.kernel.org
---
Changes since v1:
Use git format-patch -M to reduce the patch size

 .../{arm/samsung => iio/adc}/exynos-adc.txt        |    0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/devicetree/bindings/{arm/samsung => iio/adc}/exynos-adc.txt (100%)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/iio/adc/exynos-adc.txt
similarity index 100%
rename from Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
rename to Documentation/devicetree/bindings/iio/adc/exynos-adc.txt
-- 
1.7.9.5

