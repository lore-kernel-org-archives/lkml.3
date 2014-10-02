Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaJBMMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:12:48 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27633 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaJBMMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:12:46 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-cc-542d413bef8c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] Documentation: charger: max14577: Update the date of
 introducing ABI
Date: Thu, 02 Oct 2014 14:12:34 +0200
Message-id: <1412251954-29912-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJMWRmVeSWpSXmKPExsVy+t/xy7rWjrohBp0PTCxevzC0uP/1KKPF
	5u8dbBaXd81hszi9u8SB1WPTqk42jzvX9rB59G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bn
	yddYCqayV0w4v46pgXEaWxcjJ4eEgIlEb/t3JghbTOLCvfVAcS4OIYGljBJfrr1hgnD6mCT6
	WtawgFSxCRhLbF6+BKiKg0NEIFGi/ZQkSJhZIFRiSVcb2FBhgXCJy4cusYPYLAKqEucPNDOD
	2LwC7hI7VqxmhlgmJ3Hy2GTWCYzcCxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEhMCX
	HYyLj1kdYhTgYFTi4c1o0AkRYk0sK67MPcQowcGsJML7xF43RIg3JbGyKrUoP76oNCe1+BAj
	EwenVAMjz7NL66fsUEgWyc7d0Lm9bTL/X8mSTxdt5S/dkXiZxVrG4PSsoUgqjnVNU9vBQ328
	H8+ePN8c2MlR4PHC9cb7e5X2vyafOlTldNb/5a/8k1obahb+PVJ3SbenbfP0mbNk0ndurtZf
	LsLC0qhr/emkct32T+caDll5S1+OuDCt+i7Drl3+5wrDlFiKMxINtZiLihMBP6UsYt8BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the date of introducing max14577 charger's ABI (fast_charge_timer
sysfs entry) to approximate date of kernel release which actually
introduces this.

The old date came from previous driver submissions.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/ABI/testing/sysfs-class-power | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
index ad4fb90ab23d..909e7602c717 100644
--- a/Documentation/ABI/testing/sysfs-class-power
+++ b/Documentation/ABI/testing/sysfs-class-power
@@ -20,7 +20,7 @@ Description:
 		amended over time.
 
 What:		/sys/class/power_supply/max14577-charger/device/fast_charge_timer
-Date:		July 2014
+Date:		October 2014
 KernelVersion:	3.18.0
 Contact:	Krzysztof Kozlowski <k.kozlowski@samsung.com>
 Description:
-- 
1.9.1

