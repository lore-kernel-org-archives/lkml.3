Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbaJPFJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:09:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63624 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaJPFJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:09:03 -0400
X-AuditID: cbfee691-f79b86d000004a5a-9b-543f52ecad4c
From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
To: akpm@linux-foundation.org, rjw@rjwysocki.net, len.brown@intel.com,
        pavel@ucw.cz, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: cpgs@samsung.com, pintu.k@samsung.com, vishu13285@gmail.com,
        Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: [PATCH] [kernel]: process: replace printk with pr_err
Date: Thu, 16 Oct 2014 10:36:35 +0530
Message-id: <1413435995-32317-1-git-send-email-vishnu.ps@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <[kernel]: process: replace printk with pr_err>
References: <[kernel]: process: replace printk with pr_err>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkWvdNkH2IwfSjbBZz1q9hs3h5SNNi
	1pS9TBaXd81hs/jce4TR4u4poGTf98PsFmdOX2K1mNJ3l9Fiy4qHrA5cHjtn3WX3WLznJZPH
	iRm/WTy2XG1n8ejbsorRY8Xq7+wenzfJBbBHcdmkpOZklqUW6dslcGWsuP+RveA7a8XeWzvY
	GhjvsXQxcnJICJhIPHjyhB3CFpO4cG89WxcjF4eQwFJGiYfTFjLDFH3ft5AdIjGdUeJJy26o
	qj+MEvuftjCBVLEJGEpsmH0ErEpEoJdR4sv0H2DtzAJ5Eh9v/wSzhQXsJKZ//wTWwCKgKjHv
	52xWEJtXwFVi6vV7bBDrFCSWfVkLVs8pYCMxt78PLC4kYC1xffk6JpAFEgL72CUeT5nNDjFI
	QOLb5ENAD3EAJWQlNh2AOltS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/d
	xAiMjdP/nk3cwXj/gPUhRgEORiUeXs4DtiFCrIllxZW5hxhNgTZMZJYSTc4HRmBeSbyhsZmR
	hamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MPAcUzvM8q3nz9MmD
	k5MbLTYoyVcLte7Imc5ZVcJ8982VPQ83W7F4HZZaO5vnXD5LyLuXjXvD+TTa5JNkJ8SfEeJY
	Kel1ZJapX5WD4JnzPlfPflsazddwxtdyQ3h70LQ9f46v4DmvdFc1oKNsmbj4XH6RjLhbDkan
	zMtyJhz4+b+suTMv5X2fEktxRqKhFnNRcSIAjWSejYgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t9jQd3XQfYhBktvWVvMWb+GzeLlIU2L
	WVP2Mllc3jWHzeJz7xFGi7unjrJZ9H0/zG5x5vQlVospfXcZLbaseMjqwOWxc9Zddo/Fe14y
	eZyY8ZvFY8vVdhaPvi2rGD1WrP7O7vF5k1wAe1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8
	qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0H1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1D
	guB6jAzQQMIaxowV9z+yF3xnrdh7awdbA+M9li5GTg4JAROJ7/sWskPYYhIX7q1n62Lk4hAS
	mM4o8aRlN5Tzh1Fi/9MWJpAqNgFDiQ2zj7CDJEQEehklvkz/wQySYBbIk/h4+yeYLSxgJzH9
	+yewBhYBVYl5P2ezgti8Aq4SU6/fY4NYpyCx7MtasHpOARuJuf19YHEhAWuJ68vXMU1g5F3A
	yLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjynkntYFzZYHGIUYCDUYmHl+OAbYgQa2JZ
	cWXuIUYJDmYlEd65XPYhQrwpiZVVqUX58UWlOanFhxhNga6ayCwlmpwPTAp5JfGGxibmpsam
	liYWJmaWSuK8B1qtA4UE0hNLUrNTUwtSi2D6mDg4pRoYDzx5dVbxGrPC8X6LhnmJeTeSD/Dc
	jW6t+nBAryzyfrz9t3dvf5QKVYq7P9UyXShR7p/E95/B4VyJRhK738W3qYHGBTxvLp09/EXm
	ZMW68nq3DerMjdJN3XezHpeLXD479dE9dzfb939Yxepyf8w/Y3TkYfvcLQtYPkda7uI9u6Zi
	Zi3rs2pzJZbijERDLeai4kQADPWGQNICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces printk(KERN_ERR...) with pr_err found.

Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
---
 kernel/power/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 7b32322..401f7ee 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -85,7 +85,7 @@ static int try_to_freeze_tasks(bool user_only)
 
 	if (todo) {
 		printk("\n");
-		printk(KERN_ERR "Freezing of tasks %s after %d.%03d seconds "
+		pr_err("Freezing of tasks %s after %d.%03d seconds "
 		       "(%d tasks refusing to freeze, wq_busy=%d):\n",
 		       wakeup ? "aborted" : "failed",
 		       elapsed_msecs / 1000, elapsed_msecs % 1000,
-- 
1.8.3.2

