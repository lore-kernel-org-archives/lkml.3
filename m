Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbaGDRuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:50:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48632 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759696AbaGDRtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:12 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-cf-53b6e90c0c0f
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 14/19] ARM: s5pv210: Register cpufreq platform device
Date: Fri, 04 Jul 2014 19:48:14 +0200
Message-id: <1404496099-26708-15-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xy7o8L7cFGxz8pG7xd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CVsf/0cfaC
	fSwVM8+vZGtgfMncxcjJISFgInHp9zdGCFtM4sK99WxdjFwcQgJLGSX+zJvCDuH0MUnMfHWL
	CaSKTUBN4nPDIzYQW0RAVeJz2wKgIg4OZoHbTBKtwiBhYQFXiYtfVrKA2CxAJbePXASzeQWc
	Jc5PnMoOsUxOonfbG7AjOIHiE9ddABsvJOAk8ef/fJYJjLwLGBlWMYqmliYXFCel5xrpFSfm
	Fpfmpesl5+duYoSE49cdjEuPWR1iFOBgVOLhbWjZFizEmlhWXJl7iFGCg1lJhPfPKqAQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGxkkdr6U3JQioHlTi4UrNmfwpSNxbakear8SDvZ29VYcstk6e
	fFVN9vCTCxIP+uIV71ox3j3LnMEcc1k7f2J38TdxQ9GAxD0LTC6ZTc6c5vJ+TkvjFPOt017/
	nvBkcvnzs5kzIxYoNmYYZOxUzpwktDoi27eVXVYm+v8Pn13+GZOElx+OMyz+o8RSnJFoqMVc
	VJwIAM9Q3AMlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-s5pv210/s5pv210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-s5pv210/s5pv210.c b/arch/arm/mach-s5pv210/s5pv210.c
index 35db1ce..53feff3 100644
--- a/arch/arm/mach-s5pv210/s5pv210.c
+++ b/arch/arm/mach-s5pv210/s5pv210.c
@@ -59,6 +59,7 @@ static void s5pv210_dt_restart(enum reboot_mode mode, const char *cmd)
 
 static void __init s5pv210_dt_init_late(void)
 {
+	platform_device_register_simple("s5pv210-cpufreq", -1, NULL, 0);
 	s5pv210_pm_init();
 }
 
-- 
1.9.3

