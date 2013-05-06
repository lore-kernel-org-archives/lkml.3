Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3EFDo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:44:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26749 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3EFDo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:44:56 -0400
X-AuditID: cbfee68d-b7f016d000007930-46-51872737c7e4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 4/4] pinctrl: u300: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:44:55 +0900
Message-id: <002401ce4a0c$12a10ad0$37e32070$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KC+RiJivNKjagSLOAmHOc81Y/gw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zfV1z9fZAg7nr5CwuL7zEajHlz3Im
	i8u75rA5MHvcubaHzaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgy1vR8YCt4xFax4eN19gbG
	66xdjJwcEgImEls3T2GEsMUkLtxbz9bFyMUhJLCMUeLwotksMEXTzjSxQiQWMUpM3PQbquoX
	o8STibOYQKrYBNQkvnw5zA5iiwjoSbz52gJmMws4SfzcMhNoEgeHsICvxM5HMiAmi4CqRHeX
	MkgFr4ClxIxbp1ggbEGJH5PvsUB0akms33mcCcKWl9i85i0zxD0KEjvOvmaE2fS+6zHUJhGJ
	fS/eMYKcJiEwj13if1cD2CAWAQGJb5MPgZ0gISArsekA1BxJiYMrbrBMYBSbhWT1LCSrZyFZ
	PQvJigWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQiKqdwfj7QPWhxiTgdZPZJYSTc4H
	RmReSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhz
	1Sc7+J+pqTwRW/X97IRFy64wdsemJfi7Hb7PEFQTOPcg885FByv3rkq7qrOz05z1SeKsLQcf
	3wnr2TOzuHl5qeinv8+Drp92idj0J2ndWvfCF6uVmt/Jtf6+rba09oL+7IQJLz+uSUrmOZp/
	6n7+vTM2M7nrVdMNPj0V1Xk59Yjuv0txX/c8V2Ipzkg01GIuKk4EALCe7De+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgK65enugwcQWaYvLCy+xWkz5s5zJ
	4vKuOWwOzB53ru1h8+jbsorR4/MmuQDmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjDU9H9gKHrFVbPh4nb2B8TprFyMnh4SAicS0M01QtpjEhXvr2boYuTiEBBYxSkzc
	9BvK+cUo8WTiLCaQKjYBNYkvXw6zg9giAnoSb762gNnMAk4SP7fMZOli5OAQFvCV2PlIBsRk
	EVCV6O5SBqngFbCUmHHrFAuELSjxY/I9FohOLYn1O48zQdjyEpvXvGWGuEdBYsfZ14wwm953
	PYbaJCKx78U7xgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93
	EyM4Xp9J72Bc1WBxiFGAg1GJh7fgSVugEGtiWXFl7iFGCQ5mJRFen71AId6UxMqq1KL8+KLS
	nNTiQ4zJQI9OZJYSTc4HppK8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQW
	wWxh4uCUamB0v9B/w+bfa71lW+f+zLcRW3aiJmaeyqTVufsa33A+ik8TMuOb8eLL1D2dUVpF
	ml1r16WJrzleyiqee8DVoDVwzftVXBs7dkyQrN+muVTE5l5N++OjMuXmPhOWhq+zXBvExaP2
	W127mPdylJtqxa+ISr/FvrM8ZG9+7z5cZLH42aXSgh29gfeUWIozEg21mIuKEwFUmDtdGwMA	AA==
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
 drivers/pinctrl/pinctrl-u300.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 6a3a750..195191a 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1100,7 +1100,6 @@ static int u300_pmx_remove(struct platform_device *pdev)
 	struct u300_pmx *upmx = platform_get_drvdata(pdev);
 
 	pinctrl_unregister(upmx->pctl);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5


