Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3LBX2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:28:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36142 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3LBX2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:28:40 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-bc-529d17a23f47
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 32/39] video: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:28:33 +0900
Message-id: <003501ceefb6$37ba5dd0$a72f1970$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABNyQw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zQ91F4nODDNZ1Mls0L17PZnF54SVW
	ixN9H1gtLu+aw2axfv4tNgdWj/1z17B79G1Zxehx/MZ2Jo/Pm+QCWKK4bFJSczLLUov07RK4
	Mh7fWsxYsJOzYt6Xf8wNjG/Zuxg5OCQETCTO9vt1MXICmWISF+6tZ+ti5OIQEljGKNF5aioj
	RMJE4vbtSVCJ6YwSN97MZ4FwfjFKvPx3nQWkik1ATeLLl8PsILaIgKnExvdTGEGKmAV6GSWe
	rj7DBpIQErCVmP5iMxPIak4BO4m+T7UgprCAk8TXhnwQk0VAVeLQ9SKQYl6g4omz7rFB2IIS
	PybfA9vELKAlsX7ncSYIW15i85q3zBC/qEs8+qsLcYCRxIu3L6HKRST2vXgHdoyEwDV2idf9
	k8H+YhEQkPg2+RALRK+sxKYDzBDvSkocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBc
	UJyUXmSoV5yYW1yal66XnJ+7iRESm707GG8fsD7EmAy0fiKzlGhyPjC280riDY3NjCxMTUyN
	jcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBceUesa0Tn/v+XS54cxGP
	Me+mnlucadk+N5meZcpf3lxnaRCnfOzr1Alft5gf+3Tec0J0sdjU2Z+2p0YU2jBwb0t+et90
	bppZcug5B0bz5a+X6LkH/Do2vU1/xumblt8UfTk4NaO17S8eOizHzDqbs2JTTLYdz3KOrbUW
	tf/XSR1dOfW7hK1rrhJLcUaioRZzUXEiAGUOzKjjAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd2F4nODDGZOs7FoXryezeLywkus
	Fif6PrBaXN41h81i/fxbbA6sHvvnrmH36NuyitHj+I3tTB6fN8kFsEQ1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1WUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMWY8vrWYsWAnZ8W8L/+YGxjfsncxcnJICJhI3L49iQ3C
	FpO4cG89kM3FISQwnVHixpv5LBDOL0aJl/+us4BUsQmoSXz5chisW0TAVGLj+ymMIEXMAr2M
	Ek9XnwEbJSRgKzH9xWamLkYODk4BO4m+T7UgprCAk8TXhnwQk0VAVeLQ9SKQYl6g4omz7rFB
	2IISPybfA9vELKAlsX7ncSYIW15i85q3zCCtEgLqEo/+6kIcYCTx4u1LqHIRiX0v3jFOYBSa
	hWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwbH/THoH46oGi0OM
	AhyMSjy8D7bPCRJiTSwrrsw9xCjBwawkwtvJMzdIiDclsbIqtSg/vqg0J7X4EGMy0J8TmaVE
	k/OBaSmvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhh5tVVy
	+IqF+lbZzXL8c/jrpl+CBQzezCeq72rXfP97nOm34LELhvbZkuw5m6LbC9uit1rPMrq6cv4n
	l5LZFuUxk5/vdpkSdTgw6abco9BTNj8nWbDl/tvKtazkVtDzG+lrlI5rT1LqV7Vb2nnlbqnJ
	qYCdJYdmrpILbUh4E5OpoPhOyFriVK8SS3FGoqEWc1FxIgAZGAqQQQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/hyperv_fb.c |    2 +-
 drivers/video/i740fb.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
index 130708f..8254ed7 100644
--- a/drivers/video/hyperv_fb.c
+++ b/drivers/video/hyperv_fb.c
@@ -800,7 +800,7 @@ static int hvfb_remove(struct hv_device *hdev)
 }
 
 
-static DEFINE_PCI_DEVICE_TABLE(pci_stub_id_table) = {
+static const struct pci_device_id pci_stub_id_table[] = {
 	{
 		.vendor      = PCI_VENDOR_ID_MICROSOFT,
 		.device      = PCI_DEVICE_ID_HYPERV_VIDEO,
diff --git a/drivers/video/i740fb.c b/drivers/video/i740fb.c
index ca7c9df..a2b4204 100644
--- a/drivers/video/i740fb.c
+++ b/drivers/video/i740fb.c
@@ -1260,7 +1260,7 @@ fail:
 #define I740_ID_PCI 0x00d1
 #define I740_ID_AGP 0x7800
 
-static DEFINE_PCI_DEVICE_TABLE(i740fb_id_table) = {
+static const struct pci_device_id i740fb_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, I740_ID_PCI) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, I740_ID_AGP) },
 	{ 0 }
-- 
1.7.10.4


