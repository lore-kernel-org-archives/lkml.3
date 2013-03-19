Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab3CSJR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:17:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52901 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab3CSJRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:17:23 -0400
X-AuditID: cbfee68e-b7f946d000001e37-cc-51482d213e10
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Christopher Li <sparse@chrisli.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] usb: phy: samsung-usb2: Fix sparse warning
Date: Tue, 19 Mar 2013 14:45:17 +0530
Message-id: <1363684517-10354-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWyRsSkVldR1yPQYP0qHYuD9+st3j9fz2zR
	vHg9m8XlXXPYLBYta2W26FpziNWBzWPFqissHov3vGTy2D93DbvH8RvbmTw+b5ILYI3isklJ
	zcksSy3St0vgyrjwZjNrwSGeiluzoxsYD3J1MXJwSAiYSGzo8ehi5AQyxSQu3FvPBmILCSxl
	lHjyxQ6m5P1ixi5GLqDwdEaJxytmQjlTmCR2/F3MDtLAJqAr0fR2FyOILSIgK3H4ym9mkCJm
	gZWMEm+23gdLCAtYS8za3wu2gUVAVeL6vB3MIDavgIfEjZ7zbBBXKEi8uf0MrFlC4DebxLoN
	r5kgGgQkvk0+xAJxkqzEpgPMEPWSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGRXnFibnFpXrpe
	cn7uJkZgmJ7+96xvB+PNA9aHGJOBxk1klhJNzgeGeV5JvKGxmZGFqYmpsZG5pRlpwkrivGot
	1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGC1adp16crR7mkigMB+z2a4LF5UNdkSatWop
	eKxddjNv6dLo/jN+c3+eNrm1L2gWr5XPhS2rpr5nYnu2l5+zuOWktu2f20/inA2Wu1W33q3l
	e/7g3+K/R1a+PZlsUVAp0hHlzSGSsvrDSomWT2oesV3MX3+EbRJkNd/+zsFmy5sQHufTc1/s
	jlRiKc5INNRiLipOBAA00KXYaQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t9jQV1FXY9Ag+aDyhYH79dbvH++ntmi
	efF6NovLu+awWSxa1sps0bXmEKsDm8eKVVdYPBbvecnksX/uGnaP4ze2M3l83iQXwBrVwGiT
	kZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SBkkJZYk4p
	UCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHjwpvNrAWHeCpuzY5uYDzI1cXIwSEh
	YCLxfjFjFyMnkCkmceHeerYuRi4OIYHpjBKPV8xkhHCmMEns+LuYHaSKTUBXountLrAOEQFZ
	icNXfjODFDELrGSUeLP1PlhCWMBaYtb+XjYQm0VAVeL6vB3MIDavgIfEjZ7zbBDrFCTe3H7G
	PIGRewEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Eh4JrWDcWWDxSFGAQ5GJR7eE8Hu
	gUKsiWXFlbmHGCU4mJVEeIP9gUK8KYmVValF+fFFpTmpxYcYk4G2T2SWEk3OB0ZpXkm8obGJ
	uamxqaWJhYmZJWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUw7p3ZuDmtK3PpNdGY98+Y
	amTtYo6VJPM17Du8TUr0q9XE5AsKJ0I9N0gUPhT65X+1+WgiU8JG5RLuE0KtJ1fPccnpn+5e
	mFkQyfZiWdjmTm1+vxUFAWG7vl/4VRF44mqR57Pf3A5PK6oXnKzWKXzFLRk2VeG7w0mjS87L
	BNZPdKmwm/MhJu2HEktxRqKhFnNRcSIA0EPllcgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing the following sparse warning:

sparse warnings: (new ones prefixed by >>)

>> drivers/usb/phy/phy-samsung-usb2.c:50:26: sparse: incorrect type in argument 1 (different address spaces)
   drivers/usb/phy/phy-samsung-usb2.c:50:26:    expected void const volatile [noderef] <asn:2>*addr
   drivers/usb/phy/phy-samsung-usb2.c:50:26:    got void *
>> drivers/usb/phy/phy-samsung-usb2.c:73:35: sparse: incorrect type in argument 1 (different address spaces)
   drivers/usb/phy/phy-samsung-usb2.c:73:35:    expected void *regs
   drivers/usb/phy/phy-samsung-usb2.c:73:35:    got void [noderef] <asn:2>*regs

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
CC: Fengguang Wu <fengguang.wu@intel.com>
CC: Christopher Li <sparse@chrisli.org>
CC: Felipe Balbi <balbi@ti.com>
---

Based on 'next' branch of Felipe's usb tree.
Tested using make C=2 drivers/usb/phy/phy-samsung-usb2.o

Hi Felipe,

Sorry to bug you for this small change, i think this got unnoticed in the
last cycle too. Fixing it now.

Thanks
Vivek

 drivers/usb/phy/phy-samsung-usb2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index dce9681..45ffe03 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -43,7 +43,7 @@ static int samsung_usbphy_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
-static bool exynos5_phyhost_is_on(void *regs)
+static bool exynos5_phyhost_is_on(void __iomem *regs)
 {
 	u32 reg;
 
-- 
1.7.6.5

