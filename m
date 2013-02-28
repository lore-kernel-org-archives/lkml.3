Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3B1IlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:41:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36445 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3B1IlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:41:04 -0500
X-AuditID: cbfee68d-b7f636d0000009be-6c-512f181eed65
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 06/19] rtc: rtc-mc13xxx: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 17:41:02 +0900
Message-id: <00aa01ce158f$56fc8760$04f59620$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAFuUA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI105Cf1Ag3sr1CyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK2PX0FFPBXu6KntfXmBsYL3J2MXJySAiYSNy/9ZgdwhaTuHBvPVsXIxeHkMAyRomD
	PVuYYYrez33LApGYziix+dFmZgjnF6PEhenbwdrZBNQkvnw5DGRzcIgI6Eu0tWiA1DAL9DJK
	nOndDVYjJGArcaytjQXE5hSwk/j99CgriC0sECrRfHYbWJxFQFVizsI9YDYvUP2NZ33sELag
	xI/J98DizAJaEut3HmeCsOUlNq95ywyyV0JAXeLRX12IE4wkplwsh6gQkdj34h0jxC+32CWW
	PC6F2CQg8W3yIRaITlmJTQeg3pWUOLjiBssERolZSPbOQrJ3FpK9s5BsWMDIsopRNLUguaA4
	Kb3IUK84Mbe4NC9dLzk/dxMjJE57dzDePmB9iDEZaP1EZinR5HxgnOeVxBsaG5uYmZiamFua
	mpuSJqwkzit3SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+Ndt711ruttf9suk4mZdE+7
	Y+8lgXiH05eik+O/v5D8+vES36YQ5rnpa+ufcLz/9cijLcd1xd+dHIfPOV+bftsvWS/fPfX1
	97uzgzOfKZ3/b1q+YsuKotiT4aLL3ugEpPkl/5r4pth/RgrXHv/TNtN52tKm84l3zlRlSppb
	af/X4JXfAYYZ31KUWIozEg21mIuKEwGF69p76QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV05Cf1Agw+vFC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNj19BRTwV7uip7X15gbGC9ydjFyckgImEi8
	n/uWBcIWk7hwbz1bFyMXh5DAdEaJzY82M0M4vxglLkzfzg5SxSagJvHly2Egm4NDREBfoq1F
	A6SGWaCXUeJM726wGiEBW4ljbW1gUzkF7CR+Pz3KCmILC4RKNJ/dBhZnEVCVmLNwD5jNC1R/
	41kfO4QtKPFj8j2wOLOAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcX4gQjiSkXyyEqRCT2vXjH
	OIFRaBaSQbOQDJqFZNAsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSngWdSOxhX
	NlgcYhTgYFTi4e0w0QsUYk0sK67MPcQowcGsJMLrwq8fKMSbklhZlVqUH19UmpNafIgxGejP
	icxSosn5wBSVVxJvaGxiZmRpZGZhZGJuTpqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4pRoY
	K8JOPHkx3X6/2NFDNhlGB11dXsdd+pd2xL/BYMfGU6zroszd9j2ONFEODVzYVaJaGDNB/GJK
	xAGLGUlzF3boV4jYF2Sydmq/Nu7wfHuNc0Fh2PVZ/y+mNLU1+/7weLTLR8HhXkfgmsCw/o8S
	pydoCocYZV89XhrWyjHjRvSiLWdn/HRbHLNUiaU4I9FQi7moOBEA2DZ1rUcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init/__exit annotations for probe()/remove() are supposed to be
__devinit/__devexit, because __init/__exit for probe()/remove()
are not correct. However, __devinit/__devexit are not used,
because CONFIG_HOTPLUG was removed. Thus, these annotations
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-mc13xxx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 2643d88..9ae755d 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -309,7 +309,7 @@ static irqreturn_t mc13xxx_rtc_reset_handler(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static int __init mc13xxx_rtc_probe(struct platform_device *pdev)
+static int mc13xxx_rtc_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct mc13xxx_rtc *priv;
@@ -378,7 +378,7 @@ err_reset_irq_request:
 	return ret;
 }
 
-static int __exit mc13xxx_rtc_remove(struct platform_device *pdev)
+static int mc13xxx_rtc_remove(struct platform_device *pdev)
 {
 	struct mc13xxx_rtc *priv = platform_get_drvdata(pdev);
 
@@ -413,7 +413,7 @@ MODULE_DEVICE_TABLE(platform, mc13xxx_rtc_idtable);
 
 static struct platform_driver mc13xxx_rtc_driver = {
 	.id_table = mc13xxx_rtc_idtable,
-	.remove = __exit_p(mc13xxx_rtc_remove),
+	.remove = mc13xxx_rtc_remove,
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
-- 
1.7.2.5


