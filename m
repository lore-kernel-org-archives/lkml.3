Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3EFDmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:42:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25737 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3EFDmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:42:15 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-5a-518726965a1d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Fabio Estevam'" <fabio.estevam@freescale.com>,
        "'Shawn Guo'" <shawn.guo@linaro.org>
Subject: [PATCH 2/4] pinctrl: mxs: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:42:13 +0900
Message-id: <001f01ce4a0b$b21c5520$1654ff60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KC3v/TTJMmRjGR4mF1kBtvDL9jw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zA91pau2BBrt/cFjM6tK1uLzwEqvF
	lD/LmSwu75rDZvF03RJmB1aPf4f7mTzuXNvD5tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	W3+0Mxb0c1Tse76eqYHxEVsXIyeHhICJxLc/M6BsMYkL99YD2VwcQgLLGCWuntvBClP0aN4V
	RojEIkaJc5cOsUI4vxgl3my+ywxSxSagJvHly2F2EFtEQE/izdcWdpAiZoGZjBJtdw+zgCSE
	BXwkJu1pBdvHIqAq8fLKdyYQm1fAUuLCjmdQtqDEj8n3wOqZBbQk1u88zgRhy0tsXvOWGeIk
	BYkdZ18DncQBtmz/pkSIEhGJfS/egV0qIbCNXeL88/PsELsEJL5NPsQCUi8hICux6QDUGEmJ
	gytusExgFJuFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCIq5v
	B+PNA9aHGJOB1k9klhJNzgdGbF5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakF
	qUXxRaU5qcWHGJk4OKUaGJkv+U7zEwuf050QW+14x6Rtr6n91ruit7satjTF7+uoz90RMyF/
	m2nvkn/OiaYHs12lne4keW5IWcI2s8pFOm6ewOnuOSLSDbfL/l00vaS8TOqCwvKl/F6/P126
	K9w5dYbz7Rsra1Qf/5rnJsT+XPiV7Pd/Gp8tHH/G8h0tOSjSWN5gqPJgmhJLcUaioRZzUXEi
	AC3i09HOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd2pau2BBu96FS1mdelaXF54idVi
	yp/lTBaXd81hs3i6bgmzA6vHv8P9TB53ru1h8+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygvUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjK0/2hkL+jkq9j1fz9TA+Iiti5GTQ0LAROLRvCuMELaY
	xIV764HiXBxCAosYJc5dOsQK4fxilHiz+S4zSBWbgJrEly+H2UFsEQE9iTdfW9hBipgFZjJK
	tN09zAKSEBbwkZi0pxVsBYuAqsTLK9+ZQGxeAUuJCzueQdmCEj8m3wOrZxbQkli/8zgThC0v
	sXnNW2aIkxQkdpx9DXQeB9iy/ZsSIUpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525iBMfzM+kdjKsaLA4xCnAwKvHwFjxpCxRiTSwrrsw9xCjB
	wawkwuuzFyjEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cBUk1cSb2hsYmZkaWRmYWRibk6a
	sJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjDp1GZvLpznnCje0X9wU8viR37XJk9X9K6Sy
	Co+n5C287SblHT+pk+HA2vrnbM3mJgI++z9zO3NEMt9c1PnTKuab3JqfofrbFkw/lhJuyG72
	Q3H7xKzE9/bpTzq/fN37U5E9xu6VQT+/2PdtS2aaNGSZ3gqwErzotDXlpNHPWbPP1ceYXt4T
	rMRSnJFoqMVcVJwIAANFPWUrAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pinctrl/pinctrl-mxs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
index b45c4eb..f5d5643 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -515,7 +515,6 @@ int mxs_pinctrl_probe(struct platform_device *pdev,
 	return 0;
 
 err:
-	platform_set_drvdata(pdev, NULL);
 	iounmap(d->base);
 	return ret;
 }
@@ -525,7 +524,6 @@ int mxs_pinctrl_remove(struct platform_device *pdev)
 {
 	struct mxs_pinctrl_data *d = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	pinctrl_unregister(d->pctl);
 	iounmap(d->base);
 
-- 
1.7.2.5


