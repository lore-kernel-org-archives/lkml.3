Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3A1Lhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:37:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27063 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3A1Lhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:37:42 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-32-51066305cdae
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        dianders@chromium.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com
Subject: [PATCH 1/4] usb: xhci: Enable runtime pm in xhci-plat
Date: Mon, 28 Jan 2013 17:12:25 +0530
Message-id: <1359373348-18320-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSrcuazBZoMGkSv8XlXXPYLGYv6Wex
	mHF+H5PFomWtzA4sHp83yQUwRnHZpKTmZJalFunbJXBlPJxxkLlgHU/FoslPmRsYl3N1MXJy
	SAiYSKx8/Y0NwhaTuHBvPZgtJLCUUeLNt3iYmllTW5i7GLmA4osYJbadeMEO4Uxmkug/cJoV
	pIpNQFei6e0uRhBbREBW4vCV32AdzAITmSR6FjUwgSSEBewkdjdPArNZBFQl+i48YwGxeQU8
	JN4u+M0OsU5B4s3tZ8wgNqeAp8TkB2fYIU7ykJi5aD4LRM1rNol925kh5ghIfJt8CCjOARSX
	ldh0gBmiRFLi4IobLBMYhRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECAzQ0/+eSe1g
	XNlgcYhRgINRiYf3RxpLoBBrYllxZe4hRgkOZiURXoEYtkAh3pTEyqrUovz4otKc1OJDjMlA
	yycyS4km5wOjJ68k3tDYxNzU2NTSyMjM1JQ0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1
	MCa6mjftfVEwa3mYYvWtllT3NebXFWU/7p45tWT5jaZorxOLLhTEKEXauvIx6FqIb3OWeLWC
	le/NgfWXVmksWLHrU+iLoik7owQFpabn7brrIvTm2LEfbooNzO6XSqSumGcdfHLIZ+pPvhjW
	v+arj8t53bEz+hQmfJjZjnXelnNzPQNvyE0RWa3EUpyRaKjFXFScCACkSul+lAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jAV3WZLZAg1+9rBaXd81hs5i9pJ/F
	Ysb5fUwWi5a1MjuweHzeJBfAGNXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGu
	pJCXmJtqq+TiE6DrlpkDtERJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjD
	mPFwxkHmgnU8FYsmP2VuYFzO1cXIySEhYCIxa2oLM4QtJnHh3nq2LkYuDiGBRYwS2068YIdw
	JjNJ9B84zQpSxSagK9H0dhcjiC0iICtx+MpvZpAiZoGJTBI9ixqYQBLCAnYSu5sngdksAqoS
	fReesYDYvAIeEm8X/GaHWKcg8eb2M7DVnAKeEpMfnAGLCwHVzFw0n2UCI+8CRoZVjKKpBckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGMEx8ExqB+PKBotDjAIcjEo8vD/SWAKFWBPLiitzDzFKcDAr
	ifAKxLAFCvGmJFZWpRblxxeV5qQWH2JMBrpqIrOUaHI+MD7zSuINjU3MTY1NLU0sTMwsSRNW
	EudlPPUkQEggPbEkNTs1tSC1CGYLEwenVAPj4YefvWyrta880Fg/ievRD9OE20axHZ8/r2UR
	uBzKIdTs7na28Xp6zqksjh0H/X0cGCWVGSYxeCQzCd+uNmv34HP3Tp17avqTVp5TRS2PuLoE
	49d95zEV+bFGfVHGk7kLFf9O69xx9C+/98LbmqGdN19PLNu+96DO6rvWRf1HRA9a/YiKqb2m
	xFKckWioxVxUnAgAU0KuccUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By enabling runtime pm in this driver is allows users of xhci-plat to
enter into runtime pm.  This is not full runtime pm support (AKA
xhci-plat doesn't actually power anything off when in runtime suspend
mode) but just basic enablement.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/usb/host/xhci-plat.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index df90fe5..6ad7cfb 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -139,6 +139,10 @@ static int xhci_plat_probe(struct platform_device *pdev)
 		goto dealloc_usb2_hcd;
 	}
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_forbid(&pdev->dev);
+
 	/*
 	 * Set the xHCI pointer before xhci_plat_setup() (aka hcd_driver.reset)
 	 * is called by usb_add_hcd().
@@ -149,10 +153,13 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (ret)
 		goto put_usb3_hcd;
 
+	pm_runtime_allow(&pdev->dev);
+
 	return 0;
 
 put_usb3_hcd:
 	usb_put_hcd(xhci->shared_hcd);
+	pm_runtime_disable(&pdev->dev);
 
 dealloc_usb2_hcd:
 	usb_remove_hcd(hcd);
@@ -174,6 +181,8 @@ static int xhci_plat_remove(struct platform_device *dev)
 	struct usb_hcd	*hcd = platform_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 
+	pm_runtime_disable(&dev->dev);
+
 	usb_remove_hcd(xhci->shared_hcd);
 	usb_put_hcd(xhci->shared_hcd);
 
-- 
1.7.6.5

