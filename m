Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab3KLQAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:00:09 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:62779 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3KLQAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:00:07 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Roger Quadros <rogerq@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: remove dead code
In-Reply-To: <20131112152123.GF31721@saruman.home>
Organization: http://mina86.com/
References: <1384108657-23349-1-git-send-email-mpn@google.com> <20131112152123.GF31721@saruman.home>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131112:gregkh@linuxfoundation.org::QD+na+3juES9/VLt:000000000000000000000000000000000001CaA
X-Hashcash: 1:20:131112:linux-usb@vger.kernel.org::YZX6iaDcpDeKFe7z:00000000000000000000000000000000000003oG
X-Hashcash: 1:20:131112:balbi@ti.com::hVsLndKYNO4qxroB:000001gFt
X-Hashcash: 1:20:131112:rogerq@ti.com::bkoK4zNQP27s10cH:000024/+
X-Hashcash: 1:20:131112:linux-kernel@vger.kernel.org::NC5X3tunBabTVju9:0000000000000000000000000000000002wT/
X-Hashcash: 1:20:131112:balbi@ti.com::80j+cuz8wExDsDa8:000007K0R
X-Hashcash: 1:20:131112:bigeasy@linutronix.de::PxatKPqg6hUocAwe:00000000000000000000000000000000000000007ysp
Date: Tue, 12 Nov 2013 17:00:01 +0100
Message-ID: <xa1tmwl9lif2.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit [4d175f34: usb: phy: nop: Defer clock prepare until PHY init]
removed a goto reaching behind a “return ret” at the end of the function
thus removing the only possible way that statement could be reached, and
so rendering it a dead code.  This commit cleans it up by removing said
dead code.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/phy/phy-am335x.c  | 2 --
 drivers/usb/phy/phy-generic.c | 2 --
 2 files changed, 4 deletions(-)

On Tue, Nov 12 2013, Felipe Balbi wrote:
> no SoB, cannot apply.

Sorry about that.

> I already had this patch in my tree but didn't send it.  I'm fine with
> using yours but I need SoB and commit log.

I don't mind either way as long as the code gets deleted. ;)

diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
index 6370e50..48d41ab 100644
--- a/drivers/usb/phy/phy-am335x.c
+++ b/drivers/usb/phy/phy-am335x.c
@@ -66,8 +66,6 @@ static int am335x_phy_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, am_phy);

 	return 0;
-
-	return ret;
 }

 static int am335x_phy_remove(struct platform_device *pdev)
diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index fce3a9e..db4fc22 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -271,8 +271,6 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, nop);

 	return 0;
-
-	return err;
 }

 static int usb_phy_gen_xceiv_remove(struct platform_device *pdev)
--
1.8.3.2
