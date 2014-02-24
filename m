Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaBXKQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:16:33 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53234 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaBXKLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:11:22 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-62-530b1ac8ab50
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [PATCH v4 12/16] power: max17040: Add ID for max77836 Fuel Gauge block
Date: Mon, 24 Feb 2014 11:10:37 +0100
Message-id: <1393236641-14977-13-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xy7onpLiDDZbdFbc4uFXTYuOM9awW
	Ux8+YbO4/uU5q8WkJ++ZLSaunMxs8fqFocXZpjfsFve/HmW02PT4GqvF5V1z2CzWHrnLbnG6
	m9Vi/YzXLA58HhP6PzF67Jx1l91j8wotj02rOtk87lzbw+Yx72Sgx+Yl9R59W1YxenzeJBfA
	GcVlk5Kak1mWWqRvl8CV0Xirm7ngHXvF7s6jbA2Md9i6GDk5JARMJFrftzND2GISF+6tB4pz
	cQgJLGWU+Nh3kh3C6WOS6Jl+hh2kik3AWGLz8iVgVSICW5gkej98YQRxmAV6mSSunVrHCFIl
	LOAvcXkLRAeLgKrEit+rwHbwCnhIvLh2GsjmANqnIDFnkg1ImBMofLflASuILSTgLvFt3nWW
	CYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEhO6XHYyLj1kdYhTgYFTi4ZWo5goW
	Yk0sK67MPcQowcGsJMJrxssdLMSbklhZlVqUH19UmpNafIiRiYNTqoFR1XfVaSv3yR9zhfZn
	z2f7KqF0ceP5mfN+mgrVF4Re07ubY9y5tKjMYWOaYXxst3X7Uz/fXrW4mB+f2ht+xJR7ddo1
	8SlNrc97vFek+NRlQ9Pbr/X6xWIYLbbpOn+Xc877k1j74f+iXg2PBw8cN+xX35jI1H3/0U7H
	//F7Qz7//HUieOkGQyYlluKMREMt5qLiRACHTWmxOwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040. The max17040 driver can be
safely re-used. The patch adds MAX77836 ID to array with i2c_device_id.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/max17040_battery.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 0fbac861080d..165ffe381803 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
 
 static const struct i2c_device_id max17040_id[] = {
 	{ "max17040", 0 },
+	{ "max77836-battery", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
-- 
1.7.9.5

