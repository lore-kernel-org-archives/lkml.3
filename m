Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbbAIPX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:23:58 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55029 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487AbbAIPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:23:54 -0500
X-AuditID: cbfee61a-f79c06d000004e71-a4-54aff2887ae4
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH/RFC v10 05/19] mfd: max77693: Modify flash cell name identifiers
Date: Fri, 09 Jan 2015 16:22:55 +0100
Message-id: <1420816989-1808-6-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jQd2OT+tDDB7vMLDYOGM9q8XRnROZ
	LK5/ec5qMf/IOVaL3qvPGS3ONr1ht7j/9SijxeVdc9gstr5Zx2jRs2Erq8XdU0fZLHbvespq
	cfhNO6vFmf0r2Rz4PHbOusvucfjrQhaPO9f2sHnsmf+D1aNvyypGjxWrv7N7fN4kF8AexWWT
	kpqTWZZapG+XwJXxfUs7c8FltooFXTeZGhiPsHYxcnJICJhIPF/UzQ5hi0lcuLeerYuRi0NI
	YDqjxLwr/UwQTjuTxO/eiWAdbAKGEj9fvAZKcHCICERLXDpWDxJmFtjEJLHrqy6ILSwQIPHs
	/QlGEJtFQFViytx2ZhCbV8BdomPaOjaQVgkBBYk5k2xATE4BD4mW304gphBQxZurhhMYeRcw
	MqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7UZ1I7GFc2WBxiFOBgVOLh3SC3PkSINbGs
	uDL3EKMEB7OSCG/DZqAQb0piZVVqUX58UWlOavEhRmkOFiVxXiX7thAhgfTEktTs1NSC1CKY
	LBMHp1QDo3bO9HhXVcfsb75dF+cYuZYnbX+7bP+ZomiGiP1XKvQsD6oyP/BczWtRwDXL/qj9
	lk3Lv/L/jXStjMjnu7VG3nCvSvaHxkkX1834+FF+lvjKhyfM9x58UK7Ld5u9yGv+rPr5Z4TY
	e/ZaT36zzshafNOE3olNN67asG6czfVA7bL5xeubJd5y/FBiKc5INNRiLipOBACYRWGLUAIA	AA==
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

