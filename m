Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaB0LlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:41:10 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18484 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaB0LlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:41:05 -0500
X-AuditID: cbfee68e-b7f566d000002344-05-530f24508ec2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>
References: <000c01cf33b0$b1b3e050$151ba0f0$%han@samsung.com>
In-reply-to: <000c01cf33b0$b1b3e050$151ba0f0$%han@samsung.com>
Subject: [PATCH 2/2] rtc: palmas: Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 27 Feb 2014 20:41:04 +0900
Message-id: <000d01cf33b0$cbe88e30$63b9aa90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zsLGZwyDXiYdLTDm9mZzbm6I0DAAAAfTQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zY90AFf5ggxOHdS2WXLzKbjFn/Ro2
	i8sLL7FaLN23msXi8q45bBb7OzsYHdg89kw8yeZxYsZvFo/e5ndsHn1bVjF6TJ/3k8nj8ya5
	ALYoLpuU1JzMstQifbsErow9tzYwFbSyVVxqbWdqYOxm7WLk5JAQMJHomLeAHcIWk7hwbz1b
	FyMXh5DAMkaJozPvs8AU9U+ZwA6RmM4o8enwdlYI5zejxIzbPWwgVWwCahJfvhwGquLgEBHQ
	l2hr0QCpYRbYySixtms2M0iNkICtxM6JbxhBbE4BO4kvsyYzgdQLA8W3dmiAhFkEVCXaVs4H
	K+EFCi992cMCYQtK/Jh8D8xmFtCSWL/zOBOELS+xec1bZpAxEgLqEo/+6oKERQSMJBa1HWKE
	KBGR2PfiHSPIORICH9klpnWeZoLYJSDxbfIhFoheWYlNB5gh/pWUOLjiBssERolZSDbPQrJ5
	FpLNs5CsWMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJHr7djDePGB9iDEZaP1EZinR
	5Hxg9OeVxBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BkZzE6U/IX7TVlh+2/xlGuvbqR/rTy1++rmLZ8FcJ7dJ7z7zPZhmkNRvyd67lFfI/eyPL3Jm
	W8Mz79YxK36axLTc/cs0ddFVLQfWCDRM6Z1dNk3c7S17alDRKUUFKa+vK9y2+e2Yq5LYLW38
	t5TRbbOE6Z3y3++9NJrmJERd+rUpksWy5tXEMy+UWIozEg21mIuKEwFHsoZu9AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQd0AFf5gg8kPNS2WXLzKbjFn/Ro2
	i8sLL7FaLN23msXi8q45bBb7OzsYHdg89kw8yeZxYsZvFo/e5ndsHn1bVjF6TJ/3k8nj8ya5
	ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZe25tYCpoZau41NrO1MDY
	zdrFyMkhIWAi0T9lAjuELSZx4d56ti5GLg4hgemMEp8Ob2eFcH4zSsy43cMGUsUmoCbx5cth
	oA4ODhEBfYm2Fg2QGmaBnYwSa7tmM4PUCAnYSuyc+IYRxOYUsJP4MmsyE0i9MFB8a4cGSJhF
	QFWibeV8sBJeoPDSlz0sELagxI/J98BsZgEtifU7jzNB2PISm9e8ZQYZIyGgLvHory5IWETA
	SGJR2yFGiBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnp
	esn5uZsYwanhmfQOxlUNFocYBTgYlXh4f+jyBQuxJpYVV+YeYpTgYFYS4V3PxB8sxJuSWFmV
	WpQfX1Sak1p8iDEZ6NGJzFKiyfnAtJVXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU
	7NTUgtQimC1MHJxSDYx6G45a9N69UZU7/21azQ/uvQ4sn5fLPS26vib3cvmyo7YH/9mVGaw1
	P1y/aPmZXdauR7lVjBzm3HkintFb6PbN54DHU7Pnmwo9YsKXpXk+j1s7b6O+r+E67b5Xj9O9
	F2tyTFtyesbyqwKR62bt6t9yuDZhbS+zUHbzqoL7Bw+/ZGys55IPneiuxFKckWioxVxUnAgA
	P/PmuVEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-palmas.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
index fffb7d3..c360d62 100644
--- a/drivers/rtc/rtc-palmas.c
+++ b/drivers/rtc/rtc-palmas.c
@@ -348,9 +348,8 @@ static int palmas_rtc_resume(struct device *dev)
 }
 #endif
 
-static const struct dev_pm_ops palmas_rtc_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(palmas_rtc_suspend, palmas_rtc_resume)
-};
+static SIMPLE_DEV_PM_OPS(palmas_rtc_pm_ops, palmas_rtc_suspend,
+			 palmas_rtc_resume);
 
 #ifdef CONFIG_OF
 static struct of_device_id of_palmas_rtc_match[] = {
-- 
1.7.10.4


