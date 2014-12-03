Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaLCQHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:07:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:65336 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaLCQHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:07:42 -0500
X-AuditID: cbfee61a-f79c06d000004e71-35-547f353d3436
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH/RFC v9 03/19] mfd: max77693: Modify flash cell name identifiers
Date: Wed, 03 Dec 2014 17:06:38 +0100
Message-id: <1417622814-10845-4-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jQV1b0/oQg6fzhSw2zljPanF050Qm
	i+tfnrNa9L9ZyGpx7tVKRoveq88ZLc42vWG3uP/1KKPF5V1z2Cy2vlnHaNGzYSurxdLrF5ks
	7p46ymYxYfpaFovWvUfYLXbvespqcfhNO6vFmf0r2RyEPNbMW8Pocbmvl8lj56y77B4rl39h
	8zj8dSGLx6ZVnWwed67tYfPYM/8Hq0ffllWMHitWf2f3+LxJLoA7issmJTUnsyy1SN8ugSvj
	+5Z25oLLbBULum4yNTAeYe1i5OSQEDCReHRpMhOELSZx4d56ti5GLg4hgemMEs9OTWOHcNqZ
	JD5NmMoCUsUmYCjx88VroA4ODhGBaIlLx+pBapgFupkl3jTsZQSpERbwl5h+ZTUbSA2LgKrE
	47NaIGFeAQ+JWZPPs4KEJQQUJOZMsgEJcwp4Sjz9cZ8dJCwEVHJwov8ERt4FjAyrGEVTC5IL
	ipPScw31ihNzi0vz0vWS83M3MYJD/5nUDsaVDRaHGAU4GJV4eC3i6kKEWBPLiitzDzFKcDAr
	ifA++wYU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznvjZm6IkEB6YklqdmpqQWoRTJaJg1OqgdEw
	/vzefQpnOyY1NurxOG8WLDoYLadhwpQ8O2tr3eplj5SCnLMnheu/tHsvZZlv+t/BXHHWrDOl
	4fa6EyxuThLb+mD3zYPPpPwtteO8XBSKGJyj86zflk4WWOs3afF94fOPsrn17FZ33PSS5LS5
	2DV925yowg0pTootVjNfy9X+dtS/JxqWr8RSnJFoqMVcVJwIAO78OAl5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change flash cell identifiers from max77693-flash to max77693-led
to avoid confusion with NOR/NAND Flash.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max77693.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index a159593..cb14afa 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -53,8 +53,8 @@ static const struct mfd_cell max77693_devs[] = {
 		.of_compatible = "maxim,max77693-haptic",
 	},
 	{
-		.name = "max77693-flash",
-		.of_compatible = "maxim,max77693-flash",
+		.name = "max77693-led",
+		.of_compatible = "maxim,max77693-led",
 	},
 };
 
-- 
1.7.9.5

