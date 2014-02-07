Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaBGH7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:59:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34259 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaBGH7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:59:19 -0500
X-AuditID: cbfee68e-b7f566d000002344-5b-52f49256bc33
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Tony Prisk'" <linux@prisktech.co.nz>
References: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
In-reply-to: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
Subject: [PATCH 4/4] rtc: rtc-vt8500: Use devm_ioremap_resource()
Date: Fri, 07 Feb 2014 16:59:18 +0900
Message-id: <000801cf23da$808dc0d0$81a94270$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2dGo+e7pmAi4QKyN7t2QoeNN8wAAJHNw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zI92wSV+CDO6vULRYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaLlssrmC32d3YwOrB57Jl4ks3jxIzfLB7n/7ewe/RtWcXoMX3eTyaPz5vk
	AtiiuGxSUnMyy1KL9O0SuDJ6zy5kLdgkVLGp5ypjA+MU/i5GTg4JAROJ9Y2z2CBsMYkL99YD
	2VwcQgLLGCUmT5zADFP0v+8YE0RiOqPE/43TWSCcX4wSTafuMYJUsQmoSXz5cpi9i5GDQ0RA
	X6KtRQOkhllgK6PEowtH2EFqhARsJRa+7ASbyilgJ9G/p48VxBYWcJTYdmY22BwWAVWJGXsv
	gdXwAtVvvd/OAmELSvyYfA/MZhbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUEjCQ+L30E
	VS4ise/FO0aQeyQEvrJLrFnawQ6xS0Di2+RDLBC9shKbDkA9LClxcMUNlgmMErOQbJ6FZPMs
	JJtnIVmxgJFlFaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZI/PbtYLx5wPoQYzLQ+onMUqLJ
	+cD4zyuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jCtfhh09v8Rnz5mDhT5Lc1vVAvX1/V4bb5g1R2aa3vP/upWl0zTe/t4XWndqjp0bh6f+kaJ1
	anFTZoSkCe+IfvxXgU2N6Zba+hn/ReeK9U5P5m94xn57x+6/x+IDuAKNVUW2icusNUw2tX20
	kiFww5vIif3J37KnxT9Je5IxeWdCazSTeJilrRJLcUaioRZzUXEiAEmQqC/1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jQd2wSV+CDNa1ylosuXiV3WLO+jVs
	FpcXXmK1uLxrDptFy+UVzBb7OzsYHdg89kw8yeZxYsZvFo/z/1vYPfq2rGL0mD7vJ5PH501y
	AWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzes8uZC3YJFSxqecqYwPj
	FP4uRk4OCQETif99x5ggbDGJC/fWs3UxcnEICUxnlPi/cToLhPOLUaLp1D1GkCo2ATWJL18O
	s3cxcnCICOhLtLVogNQwC2xllHh04Qg7SI2QgK3EwpedzCA2p4CdRP+ePlYQW1jAUWLbmdlg
	c1gEVCVm7L0EVsMLVL/1fjsLhC0o8WPyPTCbWUBLYv3O40wQtrzE5jVvmUH2SgioSzz6qwsS
	FhEwkvi89BFUuYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLS
	vHS95PzcTYzg5PBMagfjygaLQ4wCHIxKPLwnln4OEmJNLCuuzD3EKMHBrCTC+7PhS5AQb0pi
	ZVVqUX58UWlOavEhxmSgRycyS4km5wMTV15JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNIT
	S1KzU1MLUotgtjBxcEo1MBa8ELzxeuGKrg/b4vrsbq/MtJ+0TejPxi3r0749901cpnn04Fzm
	EF7FG8rrlU/OCTly6N0sufTdHvrr1JSX3eydJ6z8Yv3tHROsTA03edp/Tp8vv99F6P2yblu5
	PUFvvp97vUHs3RnuDVz7JA9aPly6yo0ppvvhDH1F2X+XVecHZyzXzZ06f+0uJZbijERDLeai
	4kQAAYCQflIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() in order to make the code simpler,
and move 'struct resource *res' from 'struct vt8500_rtc' to
vt8500_rtc_probe() because the 'res' variable is used only in
vt8500_rtc_probe().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-vt8500.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index df2ef3e..051da96 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -79,7 +79,6 @@
 
 struct vt8500_rtc {
 	void __iomem		*regbase;
-	struct resource		*res;
 	int			irq_alarm;
 	struct rtc_device	*rtc;
 	spinlock_t		lock;		/* Protects this structure */
@@ -209,6 +208,7 @@ static const struct rtc_class_ops vt8500_rtc_ops = {
 static int vt8500_rtc_probe(struct platform_device *pdev)
 {
 	struct vt8500_rtc *vt8500_rtc;
+	struct resource	*res;
 	int ret;
 
 	vt8500_rtc = devm_kzalloc(&pdev->dev,
@@ -219,34 +219,16 @@ static int vt8500_rtc_probe(struct platform_device *pdev)
 	spin_lock_init(&vt8500_rtc->lock);
 	platform_set_drvdata(pdev, vt8500_rtc);
 
-	vt8500_rtc->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!vt8500_rtc->res) {
-		dev_err(&pdev->dev, "No I/O memory resource defined\n");
-		return -ENXIO;
-	}
-
 	vt8500_rtc->irq_alarm = platform_get_irq(pdev, 0);
 	if (vt8500_rtc->irq_alarm < 0) {
 		dev_err(&pdev->dev, "No alarm IRQ resource defined\n");
 		return vt8500_rtc->irq_alarm;
 	}
 
-	vt8500_rtc->res = devm_request_mem_region(&pdev->dev,
-					vt8500_rtc->res->start,
-					resource_size(vt8500_rtc->res),
-					"vt8500-rtc");
-	if (vt8500_rtc->res == NULL) {
-		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		return -EBUSY;
-	}
-
-	vt8500_rtc->regbase = devm_ioremap(&pdev->dev, vt8500_rtc->res->start,
-				      resource_size(vt8500_rtc->res));
-	if (!vt8500_rtc->regbase) {
-		dev_err(&pdev->dev, "Unable to map RTC I/O memory\n");
-		ret = -EBUSY;
-		goto err_return;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	vt8500_rtc->regbase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(vt8500_rtc->regbase))
+		return PTR_ERR(vt8500_rtc->regbase);
 
 	/* Enable RTC and set it to 24-hour mode */
 	writel(VT8500_RTC_CR_ENABLE,
-- 
1.7.10.4


