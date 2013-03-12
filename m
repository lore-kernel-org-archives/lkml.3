Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3CLCV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:21:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41285 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3CLCVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:21:52 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-05-513e913e2d02
Date: Tue, 12 Mar 2013 02:21:49 +0000 (GMT)
From: =?euc-kr?B?vNvAurrA?= <eunb.song@samsung.com>
Subject: Re:  [PATCH] phydev: Add sysctl variable for polling interval of phy
To: Florian Fainelli <florian@openwrt.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhutchings@solarflare.com
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130312020127083@eunb.song
Msgkey: 20130312020127083@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130312020127083@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <13502970.50091363054908513.JavaMail.weblogic@epv6ml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zpq7dRLtAg5aV4haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj74LNbAVNwRVrLmxiaWB8E9DFyMkhJKAi0fL/O2MXIweHhICJ
	xI9F8iBhCQExiQv31rN1MXIBlSxjlGhb1M0GkTCR+HlyB1RiPqPEqUurWEESLAKqEp/n3GMB
	sdmAijb8mMAOYgsL+Eq8a2pnBVkgIqAjsXGJBEgvs8AMRom963YwQRwhLzH59GWwel4BQYmT
	M5+wQCxTknh66zBUXFniyc7pjBBxCYlZ0y+wQti8EjPan0LVy0lM+7qGGcKWljg/awMjzDeL
	vz+GivNLHLsNspcDrPfJ/WCYMbs3f4H6UUBi6pmDUK3qEjOX90LZfBJrFr5lgRmz69RyZpje
	+1vmgr3CLKAoMaX7ITuErSXx5cc+NnRv8Qo4S2x9fZNtAqPyLCSpWUjaZyFpR1azgJFlFaNo
	akFyQXFSepGpXnFibnFpXrpecn7uJkZIWpi4g/H+AetDjMnAKJnILCWanA9MK3kl8YbGZkYW
	piamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYKz3/1+8YqkHj3vO
	gj2LD9cbOLk02m+Yd+D5b9tLl1ykl+U8CYyVaLj7z+6jG8dOrkMav/ea1x1RSN87dUFn8IdJ
	61UPdHxfUFGodbrXPSTQvOCe5dt9O3LvVgjf9VsUJiEvyP/Y8nbN3oAXXie0fCd9CP54NTGs
	Ii15UeghZjtTs+lJskdvfVNiKc5INNRiLipOBADXZktpIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2DF3biXaBBhP3a1pc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jL8LNrMVNAVXrLmwiaWB8U1AFyMnh5CAikTL/++MILaEgInEz5M72CBsMYkL99YD2VxANfMZ
	JU5dWsUKkmARUJX4POceC4jNBtSw4ccEdhBbWMBX4l1TO1ANB4eIgI7ExiUSIL3MAjMYJfau
	28EEsUxeYvLpy2D1vAKCEidnPmGBWKYk8fTWYai4ssSTndOhDpKQmDX9AiuEzSsxo/0pVL2c
	xLSva5ghbGmJ87M2MMIcvfj7Y6g4v8Sx2yB7OcB6n9wPhhmze/MXqB8FJKaeOQjVqi4xc3kv
	lM0nsWbhWxaYMbtOLWeG6b2/ZS7YK8wCihJTuh+yQ9haEl9+7GND9xavgLPE1tc32SYwys1C
	kpqFpH0WknZkNQsYWVYxiqYWJBcUJ6VXGOoVJ+YWl+al6yXn525iBKeoZwt3MH45b32IUYCD
	UYmH98Rn20Ah1sSy4srcQ4wSHMxKIryVKXaBQrwpiZVVqUX58UWlOanFhxiTgRE4kVlKNDkf
	mD7zSuINjQ2MDQ0tzQ1MDY0sSBNWEud92modKCSQnliSmp2aWpBaBLOFiYNTqoExz8N3qZxX
	wdJHzyewpEzIEm1Vsp38Urez6WkyH8dO+ULt/tL/ExzK3JjnPJk6c/HjqhbTHp65GVuKWoNm
	Bb42mHrpXcIps/+y/TWT5eZtefUknWF/zu6m3f9Ur2nI7zx2IsbnEZvcRXs7t0lqoSbrHj3f
	0XwzauYhnfSOyw0q+jlzDAOnPRNWYinOSDTUYi4qTgQA9Dr475UDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2C2LwY9012278


Hello. 
>Hello,

>On 03/11/2013 12:44 AM, EUNBONG SONG wrote:

>This patch should be submitted according to the rules described in: 
>https://www.kernel.org/doc/Documentation/SubmittingPatches
Sorry, i made a mistake. so i rewrite the patches here.
---
 drivers/net/phy/phy.c        |    4 +++-
 drivers/net/phy/phy_device.c |   43 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |    1 -
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef9ea92..11b773d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -42,6 +42,8 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
+extern unsigned int sysctl_phy_poll_interval;
+
 /**
  * phy_print_status - Convenience function to print out the current phy status
  * @phydev: the phy_device struct
@@ -966,7 +968,7 @@ void phy_state_machine(struct work_struct *work)
 	if (err < 0)
 		phy_error(phydev);
 
-	schedule_delayed_work(&phydev->state_queue, PHY_STATE_TIME * HZ);
+	schedule_delayed_work(&phydev->state_queue, msecs_to_jiffies(sysctl_phy_poll_interval));
 }
 
 static inline void mmd_phy_indirect(struct mii_bus *bus, int prtad, int devad,
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 3657b4a..4ed5368 100644
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
 
+unsigned int sysctl_phy_poll_interval = 1000; 
+static unsigned int min_phy_poll_interval = 1; 
+static unsigned int max_phy_poll_interval = 10000; 
+
+static struct ctl_table_header *phy_table_header;
+
+static ctl_table phy_table[] = {
+	{
+		.procname	= "phy_poll_interval",
+		.data		= &sysctl_phy_poll_interval,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler 	= &proc_dointvec_minmax,
+		.extra1		= &min_phy_poll_interval,
+		.extra2		= &max_phy_poll_interval,
+	},
+	{ }
+};
+
+static ctl_table phy_dir_table[] = {
+	{
+		.procname	= "phy",
+		.maxlen		= 0,
+		.mode 		= 0555,
+		.child		= phy_table,
+	},
+	{}
+};
+
+static ctl_table phy_root_table[] = {
+	{
+		.procname	= "dev",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= phy_dir_table,
+	},
+	{}
+};	
+
 void phy_device_free(struct phy_device *phydev)
 {
 	put_device(&phydev->dev);
@@ -1134,6 +1174,8 @@ static int __init phy_init(void)
 	if (rc)
 		mdio_bus_exit();
 
+	phy_table_header = register_sysctl_table(phy_root_table);
+
 	return rc;
 }
 
@@ -1141,6 +1183,7 @@ static void __exit phy_exit(void)
 {
 	phy_driver_unregister(&genphy_driver);
 	mdio_bus_exit();
+	unregister_sysctl_table(phy_table_header);
 }
 
 subsys_initcall(phy_init);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 33999ad..0cbc1fe 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -68,7 +68,6 @@ typedef enum {
 
 
 #define PHY_INIT_TIMEOUT	100000
-#define PHY_STATE_TIME		1
 #define PHY_FORCE_TIMEOUT	10
 #define PHY_AN_TIMEOUT		10

>Besides that, I do not think that a system-wide knob here is 
>appropriate, you may rather introduce a new ethtool ioctl() to change 
>the PHY device polling interval on a per-PHY device basis.

This patch follows current phy driver flow, "PHY_STATE_TIME" is system-wide variable for phy polling
interval. So i just replace "PHY_STATE_TIME" variable to sysctl variable. 
And I think it's better as a system-wide variable, because we usually expect all phys has same reponse-time
to the change of state. 

>Having said that don't your devices support a dedicated PHY interrupt 
>line? This would definitively be the way to get better latency with 
>respect to PHY events reported back to the host.

I usually do not interrupt because if phy state goes down, there are so many jobs for this.
For example, remove arp table entries for this port, remove all routing table entries for this port .
If we plug and unplug the physical port in very rapid speed, there could be so many interrupt events.
And this is not what we want.

>1 millisecond sounds like we are going to eat up a lot of CPU time 
>polling PHY registers. Do you need that much reactivity?

I agree with you, 1 milliseconds is very harmful to cpu. But it's just a minimum value not a default value.
Actually, i'm not sure which minimum and maximum value is best. So i just take wide range. 

Thanks



------- Original Message -------
Sender : Florian Fainelli<florian@openwrt.org>
Date : 2013-03-11 19:45 (GMT+09:00)
Title : Re: Fwd: [PATCH] phydev: Add sysctl variable for polling interval of phy

Hello,

On 03/11/2013 12:44 AM, EUNBONG SONG wrote:
>
>  From d55a22be52e5a768409aa0999d6636cdfc369676 Mon Sep 17 00:00:00 2001
> From: eunbonsong
> Date: Sun, 10 Mar 2013 04:57:39 -0700
> Subject: [PATCH] phydev: Add sysctl variable for polling interval of phy state
>
> This adds a dev.phy.phy_poll_interval sysctl variable. This value is represented in milliseconds.
> And phy_state_machine() is scheduled as this variable.
> I think HZ is enough for PC. But sometimes especially in network devices
> such as switches,routers, needs more granularity for detecting phy state change.

This patch should be submitted according to the rules described in: 
https://www.kernel.org/doc/Documentation/SubmittingPatches

Besides that, I do not think that a system-wide knob here is 
appropriate, you may rather introduce a new ethtool ioctl() to change 
the PHY device polling interval on a per-PHY device basis.

Having said that don't your devices support a dedicated PHY interrupt 
line? This would definitively be the way to get better latency with 
respect to PHY events reported back to the host.

>
>
> ---
> drivers/net/phy/phy.c        |    4 +++-
> drivers/net/phy/phy_device.c |   43 ++++++++++++++++++++++++++++++++++++++++++
> include/linux/phy.h          |    1 -
> 3 files changed, 46 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index ef9ea92..126a69f 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -42,6 +42,8 @@
> #include
> #include
>
> +extern unsigned long sysctl_phy_poll_interval;
> +
> /**
>    * phy_print_status - Convenience function to print out the current phy status
>    * @phydev: the phy_device struct
> @@ -966,7 +968,7 @@ void phy_state_machine(struct work_struct *work)
>          if (err < 0)
>                  phy_error(phydev);
>
> -       schedule_delayed_work(&phydev->state_queue, PHY_STATE_TIME * HZ);
> +       schedule_delayed_work(&phydev->state_queue, msecs_to_jiffies(sysctl_phy_poll_interval));
> }
>
> static inline void mmd_phy_indirect(struct mii_bus *bus, int prtad, int devad,
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 3657b4a..c2697e2 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -33,6 +33,7 @@
> #include
> #include
> #include
> +#include
>
> #include
> #include
> @@ -42,6 +43,45 @@ MODULE_DESCRIPTION("PHY library");
> MODULE_AUTHOR("Andy Fleming");
> MODULE_LICENSE("GPL");
>
> +unsigned long sysctl_phy_poll_interval = 1000;
> +static unsigned long min_phy_poll_interval = 1;
> +static unsigned long max_phy_poll_interval = 10000;

1 millisecond sounds like we are going to eat up a lot of CPU time 
polling PHY registers. Do you need that much reactivity?
--
FlorianˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
