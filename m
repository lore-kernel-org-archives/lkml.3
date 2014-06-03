Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaFCMIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:08:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30029 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaFCMIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:08:01 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-b2-538dbaa045a5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Robert Jarzmik'" <robert.jarzmik@free.fr>
References: <002101cf7f24$40f3e670$c2dbb350$%han@samsung.com>
In-reply-to: <002101cf7f24$40f3e670$c2dbb350$%han@samsung.com>
Subject: [PATCH 2/2] rtc: rtc-pxa: Make of_device_id array const
Date: Tue, 03 Jun 2014 21:07:59 +0900
Message-id: <002201cf7f24$760f0600$622d1200$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9/JEDaC3X0p7C2RhWGHyaVfFroSQAAA+ZQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zY90Fu3qDDSauZrVYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaLWW+ELfZ3djA6sHn0r/vM6rFn4kk2jxMzfrN49G1Zxegxfd5PJo/Pm+QC
	2KK4bFJSczLLUov07RK4Ml7OWMZe0Mtacar5H3MD43SWLkZODgkBE4ne7RvYIWwxiQv31rN1
	MXJxCAksY5R4e/4zUBEHWNGDs84Q8UWMEnMntbFAOL8ZJb7/nQHWzSagJvHly2F2kAYRAX2J
	thYNkBpmgV2MEo9vzmcGqRESsJXYdf0/G4jNKWAn8ffwKVYQW1jAQWLVt4VgNouAqsT+n8fB
	ruMFqv+/dScrhC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMkMcqi7x6K8uSFhEwEiideEpRogS
	EYl9L94xgtwjIfCRXeLzhZ3sELsEJL5NPgT1pKzEpgPMkICQlDi44gbLBEaJWUg2z0KyeRaS
	zbOQrFjAyLKKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIyR2e3cw3j5gfYgxGWj9RGYp0eR8
	YOznlcQbGpsZWZiamBobmVuakSasJM6b9DApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMj
	K/8WyaAZz/f8N/Za2pjT8N0rursz143l3zOmQ2I5T6e6du04s9Zyn852n3arJZd5JJeUH3RJ
	2lD48ECCe1+OUE6E1EW+VhN7XYlHE6ZnnFlT4VL9g/V8Vo1mzppWjrUxN44yzDrAMF3I9fIv
	oc+XXj3utL6948JRTs0lR9OX84Qd3n/BtmqrEktxRqKhFnNRcSIA3HRwsPMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAd0Fu3qDDWYeZrRYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaLWW+ELfZ3djA6sHn0r/vM6rFn4kk2jxMzfrN49G1Zxegxfd5PJo/Pm+QC
	2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWa8nLGMvaCXteJU8z/mBsbp
	LF2MHBwSAiYSD846dzFyApliEhfurWfrYuTiEBJYxCgxd1IbC4Tzm1Hi+98Z7CBVbAJqEl++
	HGYHaRYR0Jdoa9EAqWEW2MUo8fjmfGaQGiEBW4ld1/+zgdicAnYSfw+fYgWxhQUcJFZ9Wwhm
	swioSuz/eZwFxOYFqv+/dScrhC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMkMcrS7x6K8uSFhE
	wEiideEpRogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGMGJ4ZnUDsaVDRaHGAU4GJV4eH/s7QkWYk0sK67MPcQowcGsJML7b31vsBBvSmJl
	VWpRfnxRaU5q8SHGZKBHJzJLiSbnA5NWXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNL
	UrNTUwtSi2C2MHFwSjUwnjv/OduxLu1e2c+fM5S2zD9p332sm/ex1rKUx3ulKu4385QcP7Wt
	tDtZRI7fMGbiJof+Sf2PdeYn2SgcWfuJsXmOkPx2lvbqaTv2hNdM3fait7VnadOdjK/dst/O
	FzxPUJA9uLpG3u+fJL9gzbGCuXcmzWndZ/W9d2P2cedcL+Ve94PzQ2ZcU2Ipzkg01GIuKk4E
	ADopUoNQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle
it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pxa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index cccbf9d..4561f37 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -389,7 +389,7 @@ static int __exit pxa_rtc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_OF
-static struct of_device_id pxa_rtc_dt_ids[] = {
+static const struct of_device_id pxa_rtc_dt_ids[] = {
 	{ .compatible = "marvell,pxa-rtc" },
 	{}
 };
-- 
1.7.10.4


