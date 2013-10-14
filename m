Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3JNIp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:45:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52356 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3JNIp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:45:57 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-71-525baf3ff449
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Marek Vasut'" <marex@denx.de>,
        "'Shawn Guo'" <shawn.guo@linaro.org>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
In-reply-to: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
Subject: [PATCH 02/11] regulator: anatop: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:45:51 +0900
Message-id: <000101cec8b9$c967efa0$5c37cee0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOgAAAcDQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zA1379dFBBs9vq1hMffiEzeLywkus
	Ft+udDBZXN41h83iTVsjo8XTdUuYHdg85s06weKxc9Zddo9NqzrZPO5c28Pm0bdlFaPH501y
	AWxRXDYpqTmZZalF+nYJXBkz78kXdLBXnL7SwtbA2MvWxcjJISFgIrGg/wArhC0mceHeeqA4
	F4eQwDJGiZvvd7LAFM1tOM8IkVjEKPFjz0Uo5xejxOSeJnaQKjYBNYkvXw4D2RwcIgKqEv9f
	uYPUMAtsYpRoaL7KDFIjJGArcff0JTCbU8BOYuG3XWAbhIHsd/enM4HYLEC9799vZQSxeYHq
	Gzv7WCBsQYkfk++B2cwCWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHEwrf/oEpEJPa9
	eAd2s4TAS3aJw083M0LsEpD4NvkQC0SvrMSmA8wQD0tKHFxxg2UCo8QsJJtnIdk8C8nmWUhW
	LGBkWcUomlqQXFCclF5kqlecmFtcmpeul5yfu4kREr0TdzDeP2B9iDEZaP1EZinR5Hxg9OeV
	xBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbHgLkfY
	DzeD7GUOixyfLP6TdMxlYsL+GFZNlUusPzknsOdundT/aPOiIzqHtVfwli7QEVyw7fG6XdoC
	qopF+4+ph5rFOkjc3ZYhora5UvCu68Gp9cf3d5/LP7lw64c1DldjSjub3tyersLAcC8678mJ
	P3Pqp+7WfPd19+MpV2q3sv3vsnka+fKDEktxRqKhFnNRcSIAgwM9nPQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAV379dFBBmf+K1hMffiEzeLywkus
	Ft+udDBZXN41h83iTVsjo8XTdUuYHdg85s06weKxc9Zddo9NqzrZPO5c28Pm0bdlFaPH501y
	AWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzZt6TL+hgrzh9pYWtgbGX
	rYuRk0NCwERibsN5RghbTOLCvfVAcS4OIYFFjBI/9lxkhHB+MUpM7mliB6liE1CT+PLlMJDN
	wSEioCrx/5U7SA2zwCZGiYbmq8wgNUICthJ3T18CszkF7CQWftvFAmILA9nv7k9nArFZgHrf
	v98KtpkXqL6xs48FwhaU+DH5HpjNLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSSx8
	+w+qRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZwangmtYNxZYPFIUYBDkYlHl4Bp+ggIdbEsuLK3EOMEhzMSiK8gvOAQrwpiZVVqUX58UWl
	OanFhxiTgR6dyCwlmpwPTFt5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgt
	gtnCxMEp1cB4QnHa1i2T5PdsUX3y9OG3Ok3TXEez4vK2/YXOz0JuXG4PZs0pWbxcaMXCuotX
	pzEWtpze16LzXtswRGb94jBb6wDJ/r0LMtes3Hl487SZdtwCC2MZtJ5M2LKr9fXPpUlflj03
	Yt6kcPtntdIj8X3BB7MLbKYuuOb4J5qTr/hs40YzBo6ADzO1lFiKMxINtZiLihMBgqG20VED	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warning.

  WARNING: quoted string split across lines

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/anatop-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index e42bfd1..c734d09 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -255,7 +255,7 @@ static void __exit anatop_regulator_exit(void)
 }
 module_exit(anatop_regulator_exit);
 
-MODULE_AUTHOR("Nancy Chen <Nancy.Chen@freescale.com>, "
-	      "Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>");
+MODULE_AUTHOR("Nancy Chen <Nancy.Chen@freescale.com>");
+MODULE_AUTHOR("Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>");
 MODULE_DESCRIPTION("ANATOP Regulator driver");
 MODULE_LICENSE("GPL v2");
-- 
1.7.10.4


