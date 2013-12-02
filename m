Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3LBXWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:22:00 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30058 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3LBXV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:21:58 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-8e-529d16138242
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Matthew Garrett'" <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: PATCH 23/39] platform: x86: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:21:55 +0900
Message-id: <002c01ceefb5$4a627a90$df276fb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAA98xg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zA11hsblBBgd6TC2aF69ns7i88BKr
	xeVdc9gsPn6ysVi95wWzA6vH/rlr2D0WXmlm8ujbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	1yd0Cm5zVZw+u461gXEmZxcjJ4eEgInEs1Mf2CBsMYkL99YD2VwcQgLLGCUuXV3ABFN0pbWX
	FSKxiFHi+/OlUM4vRolXf46zgFSxCahJfPlymB3EFhEwldj4fgojSBGzwFxGiYvnroIVCQnY
	Skx/sRloLAcHp4CdRN+nWpCwsICnRMOdm2BnsAioSix6tAFsMy9Q+d93s1ghbEGJH5PvgY1h
	FtCSWL/zOBOELS+xec1bZpCREgLqEo/+6kKcYCRx9ttuqBIRiX0v3oGdIyFwi11i8eIPzBC7
	BCS+TT7EAtErK7HpADPEw5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpRcZ
	6hUn5haX5qXrJefnbmKERGfvDsbbB6wPMSYDrZ/ILCWanA+M7rySeENjMyMLUxNTYyNzSzPS
	hJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJz3+9Hsi5dSylucK848nhM2rX9p
	onPECSO1IFYFzna9T1nHkx0KRViaPy41cFCbyr793TyDogCVoKN5tfkXJ1Ttnn5qEccutTOb
	zzeUZ0S47Va8qn6rjeW7pnxeup+/6aofJz7LBDWH/tppmHRb84hegtHNr14KVq1x9t8EHn36
	vmwFZ7uOsBJLcUaioRZzUXEiADTA3wDkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jAV1hsblBBp0LDS2aF69ns7i88BKr
	xeVdc9gsPn6ysVi95wWzA6vH/rlr2D0WXmlm8ujbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygvUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjNcndApuc1WcPruOtYFxJmcXIyeHhICJxJXWXlYIW0zi
	wr31bF2MXBxCAosYJb4/X8oK4fxilHj15zgLSBWbgJrEly+H2UFsEQFTiY3vpzCCFDELzGWU
	uHjuKliRkICtxPQXm5m6GDk4OAXsJPo+1YKEhQU8JRru3GQDsVkEVCUWPdrABGLzApX/fTeL
	FcIWlPgx+R7YGGYBLYn1O48zQdjyEpvXvGUGGSkhoC7x6K8uxAlGEme/7YYqEZHY9+Id4wRG
	oVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc+8+kdjCubLA4
	xCjAwajEw/tg+5wgIdbEsuLK3EOMEhzMSiK8nTxzg4R4UxIrq1KL8uOLSnNSiw8xJgM9OpFZ
	SjQ5H5iW8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcfqs
	Dw8yNS7sZVnoddpSitf7z0XRAi01gf3Ms1mnnal6tm+WQKSzWvRng5qFNxWrju2fPn9SyM5l
	Dw79Mj93iP/wg2UfNq1f9o9pw8X3R56ysrS437uo/aw66mhpQcp9vsXxOzevnvDE9Jg7zzXN
	n9/y6/9/fLwi63msm2SC12nxdtlmlbvzU+cosRRnJBpqMRcVJwIALz6xZ0EDAAA=
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
 drivers/platform/x86/intel_ips.c     |    2 +-
 drivers/platform/x86/intel_scu_ipc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 18dcb58..a0d1f57 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -1478,7 +1478,7 @@ ips_link_to_i915_driver(void)
 }
 EXPORT_SYMBOL_GPL(ips_link_to_i915_driver);
 
-static DEFINE_PCI_DEVICE_TABLE(ips_id_table) = {
+static const struct pci_device_id ips_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL,
 		     PCI_DEVICE_ID_INTEL_THERMAL_SENSOR), },
 	{ 0, }
diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 60ea476..6a39f03 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -649,7 +649,7 @@ static void ipc_remove(struct pci_dev *pdev)
 	intel_scu_devices_destroy();
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
+static const struct pci_device_id pci_ids[] = {
 	{PCI_VDEVICE(INTEL, 0x082a), SCU_IPC_LINCROFT},
 	{PCI_VDEVICE(INTEL, 0x080e), SCU_IPC_PENWELL},
 	{PCI_VDEVICE(INTEL, 0x08ea), SCU_IPC_CLOVERVIEW},
-- 
1.7.10.4


