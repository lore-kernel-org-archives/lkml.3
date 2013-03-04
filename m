Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3CDIHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:07:34 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33672 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3CDIHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:07:32 -0500
X-AuditID: cbfee68d-b7f636d0000009be-b6-51345641f9e1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 24/24] rtc: rtc-tx4939: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:07:28 +0900
Message-id: <015201ce18af$50832b00$f1898100$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAV0GQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zA13HMJNAg97JHBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlnPqTXfCAveLVqZ2sDYzX2LoYOTkkBEwkWiYeYoSwxSQu3FsPFhcSWMYosWSJG0zN
	6q07mSHi0xkljveZdjFyAdm/GCWaHq1iAUmwCahJfPlymL2LkYNDREBfoq1FA6SGWaCXUeJM
	7252iGZbiS8PHzCB2JwCdhL3z61iBbGFBbwkrvx5B2azCKhKvPmyGewgXqD6lgtroWxBiR+T
	74HtYhbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUEjCT2rT/KDlEiIrHvxTtGkHskBO6x
	Sxz78JkNYpeAxLfJh1ggemUlNh1ghvhXUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHU
	guSC4qT0IkO94sTc4tK8dL3k/NxNjJAo7d3BePuA9SHGZKD1E5mlRJPzgVGeVxJvaGxsYmZi
	amJuaWpuSpqwkjiv3CWZQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MDpGn/CN5rvkVp357
	f5hxc7fT7/lcix5qf+px1inaJO7mc2yi0sEUf4/U5KcnJ0Z82fpfKdD8H79ILK/tKt3/a4Pq
	C9iuqkRmGH1s2Lk4a+v70OK7f8UKukVPKe9Wu7BGMX3D09nxSZtyThkvDpX2VV6w/uLP/KOX
	uiLd+VNFOku2TAhOvDZXiaU4I9FQi7moOBEA9K9qCegCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV3HMJNAg/MTWCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDj1J7vgAXvFq1M7WRsYr7F1MXJySAiYSKze
	upMZwhaTuHBvPVhcSGA6o8TxPtMuRi4g+xejRNOjVSwgCTYBNYkvXw6zdzFycIgI6Eu0tWiA
	1DAL9DJKnOndzQ7RbCvx5eEDJhCbU8BO4v65VawgtrCAl8SVP+/AbBYBVYk3XzYzgti8QPUt
	F9ZC2YISPybfA9vFLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSexbf5QdokREYt+L
	d4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcBJ4JrWD
	cWWDxSFGAQ5GJR5egU/GgUKsiWXFlbmHGCU4mJVEeMskTAKFeFMSK6tSi/Lji0pzUosPMSYD
	PTqRWUo0OR+YoPJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1OzW1ILUIZgsTB6dU
	A+OU24JBLHdOXDo6e6fXpD8/Hh1S5HaxfW3ks3jXJUe3VsW2/KKkzOfJOX8/mC1RP7V79+K/
	JS03TgdaXdrSsfQU90azdmnRQ4//Ru6YG5C8zXjD7ONrjlW+njnLv/Sh81+XhP7jCYormoQ3
	TZjf1Jaw9AXHlwjPmCed7+W2ullUMUpkXpzKNIVJiaU4I9FQi7moOBEA+feGs0YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-tx4939.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index a12bfac..4f2c082 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -299,18 +299,7 @@ static struct platform_driver tx4939_rtc_driver = {
 	},
 };
 
-static int __init tx4939rtc_init(void)
-{
-	return platform_driver_probe(&tx4939_rtc_driver, tx4939_rtc_probe);
-}
-
-static void __exit tx4939rtc_exit(void)
-{
-	platform_driver_unregister(&tx4939_rtc_driver);
-}
-
-module_init(tx4939rtc_init);
-module_exit(tx4939rtc_exit);
+module_platform_driver_probe(tx4939_rtc_driver, tx4939_rtc_probe);
 
 MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("TX4939 internal RTC driver");
-- 
1.7.2.5


