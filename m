Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3LBXSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:18:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14701 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3LBXS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:18:29 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-67-529d1544ed4d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Brian Norris'" <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 19/39] mtd: denali: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:18:28 +0900
Message-id: <002801ceefb4$cef24a20$6cd6de60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAA2u/w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zY10X0blBBk+/61scubCW2WLiysnM
	Fs2L17NZXF54idXi8q45bBa7m5axO7B57Jx1l91j8wotj/1z1wAZS+o9+rasYvT4vEkugC2K
	yyYlNSezLLVI3y6BK+PC5iVMBYvZKq4tf8bSwDiXtYuRk0NCwETiTsN3FghbTOLCvfVsXYxc
	HEICyxgl9i/pYoEpOty0lxEisYhRYvaqL6wQzi9Gib9vX4ONYhNQk/jy5TA7iC0iYCqx8f0U
	sA5mgX2MEie7XjKDJIQEbCWmv9jM1MXIwcEpYCfR96kWJCws4CFx+cIyNhCbRUBVYu32icwg
	JbxA5Rdn2oCEeQUEJX5Mvgd2ELOAlsT6nceZIGx5ic1r3oKVSwioSzz6qwtxgZHEsbtfmSFK
	RCT2vXgHdo2EwEd2iY6X11ggVglIfJt8iAWiV1Zi0wFmiH8lJQ6uuMEygVFiFpLNs5BsnoVk
	8ywkKxYwsqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECIncvh2MNw9YH2JMBlo/kVlKNDkf
	GPl5JfGGxmZGFqYmpsZG5pZmpAkrifMuepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx
	8gJXDR1bj7CECTa/49t/et76Y/HG/GT65X+n3F2m5e0s+fD6dbxZ1K53QYuY1u6RsxRtU5gf
	dXvhjJn/12YXGO7ymfyTeal3oifzd7ECl/QPak93nv+/4PjnwoDO1BSf7pNXisKZ1gvMqr/m
	xbV7xlu7Ky8mfhBbVv5m5uXDx/geH0jns+0vVGIpzkg01GIuKk4EAGe/feryAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAV0X0blBBj++aVscubCW2WLiysnM
	Fs2L17NZXF54idXi8q45bBa7m5axO7B57Jx1l91j8wotj/1z1wAZS+o9+rasYvT4vEkugC2q
	gdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gKJYWy
	xJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGhc1LmAoWs1VcW/6MpYFxLmsX
	IyeHhICJxOGmvYwQtpjEhXvr2boYuTiEBBYxSsxe9YUVwvnFKPH37WuwDjYBNYkvXw6zg9gi
	AqYSG99PYQQpYhbYxyhxsuslM0hCSMBWYvqLzUxdjBwcnAJ2En2fakHCwgIeEpcvLGMDsVkE
	VCXWbp/IDFLCC1R+caYNSJhXQFDix+R7LCA2s4CWxPqdx5kgbHmJzWvegpVLCKhLPPqrC3GB
	kcSxu1+ZIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al
	6yXn525iBKeFZ9I7GFc1WBxiFOBgVOLhfbB9TpAQa2JZcWXuIUYJDmYlEd5OnrlBQrwpiZVV
	qUX58UWlOanFhxiTgf6cyCwlmpwPTFl5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJ
	zU5NLUgtgtnCxMEp1cDYnX61OdvtTc46/fciv9dP15TTc9i6orxs/sFDs9MNre2tZAPf7t+q
	FlvatCUkayG77Q7T55x81RdnJSUq2UhYbLWf9lL9+Bvnehdm1QZJuWk/Pz1z3+X4QmDz7qev
	Tzg/qJK4OiPhhcsOmeUaoSIns5d07cvew7gneLHW5+2LeiufPNac0nZNiaU4I9FQi7moOBEA
	ipMewk8DAAA=
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
 drivers/mtd/nand/denali_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/denali_pci.c b/drivers/mtd/nand/denali_pci.c
index 033f177..622dfb7 100644
--- a/drivers/mtd/nand/denali_pci.c
+++ b/drivers/mtd/nand/denali_pci.c
@@ -21,7 +21,7 @@
 #define DENALI_NAND_NAME    "denali-nand-pci"
 
 /* List of platforms this NAND controller has be integrated into */
-static DEFINE_PCI_DEVICE_TABLE(denali_pci_ids) = {
+static const struct pci_device_id denali_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x0701), INTEL_CE4100 },
 	{ PCI_VDEVICE(INTEL, 0x0809), INTEL_MRST },
 	{ /* end: all zeroes */ }
-- 
1.7.10.4


