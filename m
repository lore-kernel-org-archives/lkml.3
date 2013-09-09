Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab3IIFRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:17:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45479 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3IIFRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:17:34 -0400
X-AuditID: cbfee68e-b7f756d000004512-75-522d59ecdd01
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] staging: dgrp: Remove casting the return value which is a
 void pointer
Date: Mon, 09 Sep 2013 14:17:32 +0900
Message-id: <004301cead1b$e3272a00$a9757e00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6tG+MPdGOj+j+ZT3mKmVwvD3OitA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t8zA903kbpBBqs2mlk0L17PZnF54SVW
	i8u75rA5MHvsn7uG3aNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgyPl++xlowQ65iy9tpTA2M
	a8W7GDk5JARMJLatXc8KYYtJXLi3nq2LkYtDSGAZo8TG1t+MMEUvt71kA7GFBBYxSuzqd4Io
	+sUo0bi5gQUkwSagJvHly2F2EFtEwFRi4/spQM0cHMwCLhJHp4mAhIUFYiUWP5kHVsIioCox
	+c4ZsMW8ArYSk5ZvY4KwBSV+TL4HNpJZQEti/c7jTBC2vMTmNW+ZQUZKCKhLPPqrC7FJT+LT
	2hNQJSIS+168gzp5GbvE7xNWEKsEJL5NPsQC0SorsekAM0SJpMTBFTdYJjCKzUKyeBaSxbOQ
	LJ6FZMMCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCHR1LeD8eYB60OMyUDrJzJLiSbn
	A6MxryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M
	E9lMmES/uTxUXrF/9ju71QZvFfUdtul9ml7k+fEJ54rzq1YdWft0/6V/O1e/XXJLY0nVrfO6
	OgvePXSsCKyJyL5507eFb+Obxf8ny+lecToWtrp9FwNPbYGcm5nAPwOG4OW/590Qq7jP+uZx
	8tIja1it3+ZkLPnb4yjkaW9aPXen2+zyX1PMNyuxFGckGmoxFxUnAgCX2I13vAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xgO6bSN0gg/u9RhbNi9ezWVxeeInV
	4vKuOWwOzB77565h9+jbsorR4/MmuQDmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjM+Xr7EWzJCr2PJ2GlMD41rxLkZODgkBE4mX216yQdhiEhfurQezhQQWMUrs6nfq
	YuQCsn8xSjRubmABSbAJqEl8+XKYHcQWETCV2Ph+CmMXIwcHs4CLxNFpIiBhYYFYicVP5oGV
	sAioSky+c4YVxOYVsJWYtHwbE4QtKPFj8j2wkcwCWhLrdx5ngrDlJTavecsMMlJCQF3i0V9d
	iE16Ep/WnoAqEZHY9+Id4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1ya
	l66XnJ+7iREcrc+kdjCubLA4xCjAwajEwyvxXydIiDWxrLgy9xCjBAezkgjv+edAId6UxMqq
	1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJpK8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5ak
	ZqemFqQWwWxh4uCUamCMPHSwb2EWU4W1V8ut8l3yzqvPrd2V/Pi1dvqXUHWj1luWy+ZvvTYz
	l2mOxTfFjw9ynVsKH64XFF0tdG7igcxb8168u7Dp/euzJ87Kr+h5HmOpqpM686OyJbPvJsZl
	U9M37q751MbdFSO2Z1rw5nSNKUG160K/WPXEnN/M4sTtrBKi75uoP6NPiaU4I9FQi7moOBEA
	EL7wwhoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting the return value which is a void pointer is redundant.
The conversion from void pointer to any other pointer type is
guaranteed by the C programming language.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/staging/dgrp/dgrp_sysfs.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_sysfs.c b/drivers/staging/dgrp/dgrp_sysfs.c
index 8cee9c8..9a18a2c 100644
--- a/drivers/staging/dgrp/dgrp_sysfs.c
+++ b/drivers/staging/dgrp/dgrp_sysfs.c
@@ -157,7 +157,7 @@ static ssize_t dgrp_node_state_show(struct device *c,
 
 	if (!c)
 		return 0;
-	nd = (struct nd_struct *) dev_get_drvdata(c);
+	nd = dev_get_drvdata(c);
 	if (!nd)
 		return 0;
 
@@ -174,7 +174,7 @@ static ssize_t dgrp_node_description_show(struct device *c,
 
 	if (!c)
 		return 0;
-	nd = (struct nd_struct *) dev_get_drvdata(c);
+	nd = dev_get_drvdata(c);
 	if (!nd)
 		return 0;
 
@@ -192,7 +192,7 @@ static ssize_t dgrp_node_hw_version_show(struct device *c,
 
 	if (!c)
 		return 0;
-	nd = (struct nd_struct *) dev_get_drvdata(c);
+	nd = dev_get_drvdata(c);
 	if (!nd)
 		return 0;
 
@@ -212,7 +212,7 @@ static ssize_t dgrp_node_hw_id_show(struct device *c,
 
 	if (!c)
 		return 0;
-	nd = (struct nd_struct *) dev_get_drvdata(c);
+	nd = dev_get_drvdata(c);
 	if (!nd)
 		return 0;
 
@@ -232,7 +232,7 @@ static ssize_t dgrp_node_sw_version_show(struct device *c,
 	if (!c)
 		return 0;
 
-	nd = (struct nd_struct *) dev_get_drvdata(c);
+	nd = dev_get_drvdata(c);
 	if (!nd)
 		return 0;
 
@@ -311,7 +311,7 @@ static ssize_t dgrp_tty_state_show(struct device *d,
 
 	if (!d)
 		return 0;
-	un = (struct un_struct *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un)
 		return 0;
 
@@ -328,7 +328,7 @@ static ssize_t dgrp_tty_baud_show(struct device *d,
 
 	if (!d)
 		return 0;
-	un = (struct un_struct *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un)
 		return 0;
 	ch = un->un_ch;
@@ -348,7 +348,7 @@ static ssize_t dgrp_tty_msignals_show(struct device *d,
 
 	if (!d)
 		return 0;
-	un = (struct un_struct *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un)
 		return 0;
 	ch = un->un_ch;
@@ -377,7 +377,7 @@ static ssize_t dgrp_tty_iflag_show(struct device *d,
 
 	if (!d)
 		return 0;
-	un = (struct un_struct *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un)
 		return 0;
 	ch = un->un_ch;
@@ -396,7 +396,7 @@ static ssize_t dgrp_tty_cflag_show(struct device *d,
 
 	if (!d)
 		return 0;
-	un = (struct un_struct *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un)
 		return 0;
 	ch = un->un_ch;
@@ -415,7 +415,7 @@ static ssize_t dgrp_tty_oflag_show(struct device *d,
 
 	if (!d)
 		return 0;
-	un = (struct un_struct *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un)
 		return 0;
 	ch = un->un_ch;
@@ -434,7 +434,7 @@ static ssize_t dgrp_tty_digi_flag_show(struct device *d,
 
 	if (!d)
 		return 0;
-	un = (struct un_struct *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un)
 		return 0;
 	ch = un->un_ch;
@@ -453,7 +453,7 @@ static ssize_t dgrp_tty_rxcount_show(struct device *d,
 
 	if (!d)
 		return 0;
-	un = (struct un_struct *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un)
 		return 0;
 	ch = un->un_ch;
@@ -472,7 +472,7 @@ static ssize_t dgrp_tty_txcount_show(struct device *d,
 
 	if (!d)
 		return 0;
-	un = (struct un_struct *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un)
 		return 0;
 	ch = un->un_ch;
@@ -493,7 +493,7 @@ static ssize_t dgrp_tty_name_show(struct device *d,
 
 	if (!d)
 		return 0;
-	un = (struct un_struct *) dev_get_drvdata(d);
+	un = dev_get_drvdata(d);
 	if (!un)
 		return 0;
 	ch = un->un_ch;
-- 
1.7.10.4


