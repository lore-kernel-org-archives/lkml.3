Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3CJXmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 19:42:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17015 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3CJXm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 19:42:27 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-1e-513d1a610cc0
Date: Sun, 10 Mar 2013 23:42:25 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] phydev: Add sysctl variable for polling interval of phy
To: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
        "davem@davemloft.net" <davem@davemloft.net>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130310232857557@eunb.song
Msgkey: 20130310232857557@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130310232857557@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <13680737.6931362958945051.JavaMail.weblogic@epv6ml10>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Znm6ilG2gwet5+haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjw6nbzAUntCtO3HzJ3sC4RauLkZNDSEBFouX/d0YQW0LARGLh
	sv9QtpjEhXvr2boYuYBqljFKXD7byQ5TtGfRSnaI5vmMEmdmm3UxcnCwCKhKPL+UDxJmE9CW
	ePvlAStIWFjAQ+J/nx1IWESgTOLe9iVsEJ3yEpNPXwabwisgKHFy5hMWiOlKEhPb3zNDxJUl
	Xm9fwQoRl5CYNf0ClM0rMaP9KVS9nMS0r2uYIWxpifOzNsCdv/j7Y6g4v8Sx2zuYQM4B6X1y
	PxhmzO7NX9ggbAGJqWcOQrWqS3xp2cMEYfNJrFn4lgVmzK5Ty5lheu9vmQtWwyygKDGl+yE7
	hK0l8eXHPjZ0b/EKOEncbV/HCgpNCYFeDomvk9cwT2BUmoWkbhaSWbOQzEJWs4CRZRWjaGpB
	ckFxUnqRqV5xYm5xaV66XnJ+7iZGSFKYuIPx/gHrQ4zJwBiZyCwlmpwPTCp5JfGGxmZGFqYm
	psZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDcLnPuzLzYw68MUtWY
	2PuULmWobEq68tc64upTXeblus0fJsxLWHDgnsPN3jeeHKLym/vDtvtaGfiba/G+8bh83fu3
	8LbvH3fsW1N0T7HkxqOtdgvvBkZKzOtdJKZcsX/jA/YP38TnzPhbETc9eX/cxqTpiyc8vWs2
	T75KWdndc+eZz1+F134+psRSnJFoqMVcVJwIAMpbrRQgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsVy+t/t6bqJUraBBju3allc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jA2nbjMXnNCuOHHzJXsD4xatLkZODiEBFYmW/98ZQWwJAROJPYtWskPYYhIX7q1ng6iZzyhx
	ZrZZFyMHB4uAqsTzS/kgYTYBbYm3Xx6wgoSFBTwk/vfZgYRFBMok7m1fAtUpLzH59GWwibwC
	ghInZz5hgZiuJDGx/T0zRFxZ4vX2FawQcQmJWdMvQNm8EjPan0LVy0lM+7qGGcKWljg/awMj
	zJWLvz+GivNLHLu9gwnkHJDeJ/eDYcbs3vyFDcIWkJh65iBUq7rEl5Y9TBA2n8SahW9ZYMbs
	OrWcGab3/pa5YDXMAooSU7ofskPYWhJffuxjQ/cWr4CTxN32dawTGGVnIUnNQtI+C0k7spoF
	jCyrGEVTC5ILipPSKwz1ihNzi0vz0vWS83M3MYKT0LOFOxi/nLc+xCjAwajEw/uh2DpQiDWx
	rLgy9xCjBAezkgjvyk02gUK8KYmVValF+fFFpTmpxYcYk4FRNpFZSjQ5H5gg80riDY0NjA0N
	Lc0NTA2NLEgTVhLnfdoKtFUgPbEkNTs1tSC1CGYLEwenVANj0PmulHdSq6bmt1rcyNyefu44
	89LeqkrvgJWMW/c8TtfXP3wy5p5l49E7hz92nW+9X3juxpF/MXd2KkUmRz0SMRXOvRm951/F
	vOKT66ccmlEuHj/Lt0Bal3NRmNRSE+Frgae7tcyZblpl1057u23mJu6F3690n3l926iHf8Ph
	dwJSugZP+fSuKrEUZyQaajEXFScCALDlKZuGAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2ANgYiW004645


>From d55a22be52e5a768409aa0999d6636cdfc369676 Mon Sep 17 00:00:00 2001
From: eunbonsong <eunb.song@samsung.com>
Date: Sun, 10 Mar 2013 04:57:39 -0700
Subject: [PATCH] phydev: Add sysctl variable for polling interval of phy state

This adds a dev.phy.phy_poll_interval sysctl variable. This value is represented in milliseconds.
And phy_state_machine() is scheduled as this variable. 
I think HZ is enough for PC. But sometimes especially in network devices
such as switches,routers, needs more granularity for detecting phy state change. 


---
 drivers/net/phy/phy.c        |    4 +++-
 drivers/net/phy/phy_device.c |   43 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |    1 -
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef9ea92..126a69f 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -42,6 +42,8 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>

+extern unsigned long sysctl_phy_poll_interval;
+
 /**
  * phy_print_status - Convenience function to print out the current phy status
  * @phydev: the phy_device struct
@@ -966,7 +968,7 @@ void phy_state_machine(struct work_struct *work)
        if (err < 0)
                phy_error(phydev);

-       schedule_delayed_work(&phydev->state_queue, PHY_STATE_TIME * HZ);
+       schedule_delayed_work(&phydev->state_queue, msecs_to_jiffies(sysctl_phy_poll_interval));
 }

 static inline void mmd_phy_indirect(struct mii_bus *bus, int prtad, int devad,
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 3657b4a..c2697e2 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -33,6 +33,7 @@
 #include <linux/mii.h>
 #include <linux/ethtool.h>
 #include <linux/phy.h>
+#include <linux/sysctl.h>

 #include <asm/io.h>
 #include <asm/irq.h>
@@ -42,6 +43,45 @@ MODULE_DESCRIPTION("PHY library");
 MODULE_AUTHOR("Andy Fleming");
 MODULE_LICENSE("GPL");

+unsigned long sysctl_phy_poll_interval = 1000; 
+static unsigned long min_phy_poll_interval = 1; 
+static unsigned long max_phy_poll_interval = 10000; 
+
+static struct ctl_table_header *phy_table_header;
+
+static ctl_table phy_table[] = {
+       {
+               .procname       = "phy_poll_interval",
+               .data           = &sysctl_phy_poll_interval,
+               .maxlen         = sizeof(long),
+               .mode           = 0644,
+               .proc_handler   = proc_dointvec_minmax,
+               .extra1         = &min_phy_poll_interval,
+               .extra2         = &max_phy_poll_interval,
+       },
+       { }
+};
+
+static ctl_table phy_dir_table[] = {
+       {
+               .procname       = "phy",
+               .maxlen         = 0,
+               .mode           = 0555,
+               .child          = phy_table,
+       },
+       {}
+};
+
+static ctl_table phy_root_table[] = {
+       {
+               .procname       = "dev",
+               .maxlen         = 0,
+               .mode           = 0555,
+               .child          = phy_dir_table,
+       },
+       {}
+};     
+
 void phy_device_free(struct phy_device *phydev)
 {
        put_device(&phydev->dev);
@@ -1134,6 +1174,8 @@ static int __init phy_init(void)
        if (rc)
                mdio_bus_exit();

+       phy_table_header = register_sysctl_table(phy_root_table);
+
        return rc;
 }

@@ -1141,6 +1183,7 @@ static void __exit phy_exit(void)
 {
        phy_driver_unregister(&genphy_driver);
        mdio_bus_exit();
+       unregister_sysctl_table(phy_table_header);
 }

 subsys_initcall(phy_init);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 33999ad..0cbc1fe 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -68,7 +68,6 @@ typedef enum {


 #define PHY_INIT_TIMEOUT       100000
-#define PHY_STATE_TIME         1
 #define PHY_FORCE_TIMEOUT      10
 #define PHY_AN_TIMEOUT         10

-- 
1.7.10.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
