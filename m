Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbaDBHeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:34:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31129 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956AbaDBHeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:34:01 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-36-533bbd6738a2
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 02/10] ARM: EXYNOS: Correct file path in comment message
Date: Wed, 02 Apr 2014 16:50:53 +0900
Message-id: <1396425058-4012-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t8zQ930vdbBBi0TzSyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wu7A7tHS3MPmsXlJvUffllWMHp83yQWwRHHZpKTm
	ZJalFunbJXBl3LmwjL3gNUvFxRWv2BoYe1m6GDk5JARMJHZ3PmKDsMUkLtxbD2RzcQgJLGOU
	mLFsDxNM0aNL/SwQiUWMEntvn2SFcNqYJG6+PMYIUsUmoCvx5P1cZhBbRCBb4tKsW2ArmAWK
	JN6s+wO2QljAQ+LHtJ9AzRwcLAKqEvOfloOEeQXcJe7Ne8AGEpYQUJCYM8kGJMwJVH2/pYUd
	xBYCKpl7YyfYWgmByewSq393gI1kERCQ+Db5EAtEr6zEpgPMEDdLShxccYNlAqPwAkaGVYyi
	qQXJBcVJ6UWmesWJucWleel6yfm5mxghYT1xB+P9A9aHGJOBxk1klhJNzgfGRV5JvKGxmZGF
	qYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MNbN5ag+y3fMQlVl
	/bmS4ts/p61gbBQ8+q28W2vGIufoiyzbAieuaU7Z9XlleOb3dyeEYz4y1JWZqvr4K+vO7ig8
	2WndO0cwZ/Nj9dD853J6/f1LrQ113mnd2Nj4qKPdQ3Dl3xfHViVGTsifzhxVeOhLdlv6lXWF
	ir0GP82+aBpG33gU/KSpSYmlOCPRUIu5qDgRAHxxcLmBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jAd30vdbBBsv7jCyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wu7A7tHS3MPmsXlJvUffllWMHp83yQWwRDUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaCkUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLhzYRl7wWuWiosrXrE1MPaydDFyckgI
	mEg8utQPZYtJXLi3nq2LkYtDSGARo8Te2ydZIZw2JombL48xglSxCehKPHk/lxnEFhHIlrg0
	6xZYN7NAkcSbdX/YQGxhAQ+JH9N+AjVzcLAIqErMf1oOEuYVcJe4N+8BG0hYQkBBYs4kG5Aw
	J1D1/ZYWdhBbCKhk7o2drBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI6aZ9I7
	GFc1WBxiFOBgVOLhPXDeKliINbGsuDL3EKMEB7OSCC/nJOtgId6UxMqq1KL8+KLSnNTiQ4zJ
	QDdNZJYSTc4HRnReSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBK
	NTDWtBSlc9f809134Fr1e7PwNW5MPce9en5G7rzr15B4SkBiVXxW3WbtM7MfiRu2LDELuv9i
	Ecs+tbMbrBdcuO952vHLBK9jvc6ZJllf2dhPO7zyCDcJ9fq4tS8z9JRrqeBdt7QwR9cbAv0h
	Fyx3xD1Y52nWrv1xWqnw8QLvn7ZBDzcsX7Vh3QMlluKMREMt5qLiRACqejKA3gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects file path mentioned in file comment message.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/platsmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 03e5e9f..d8d1555 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -1,4 +1,4 @@
-/* linux/arch/arm/mach-exynos4/platsmp.c
+/* linux/arch/arm/mach-exynos/platsmp.c
  *
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
-- 
1.7.10.4

