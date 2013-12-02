Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3LBXIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:08:49 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33059 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3LBXIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:08:46 -0500
X-AuditID: cbfee690-b7f126d00000418c-d0-529d12fd562a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 08/39] gpio: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:08:45 +0900
Message-id: <001d01ceefb3$733b8cb0$59b2a610$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAhD1w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zA92/QnODDD6fkrRoXryezeLywkus
	FlP+LGey2Dz/D6PF5V1z2BxYPe5c28PmsX/uGnaPvi2rGD0+b5ILYInisklJzcksSy3St0vg
	ypjacZ+p4Kl0xdeL7xgbGA+KdzFyckgImEicXrKQCcIWk7hwbz0biC0ksIxR4sqTSJiaW0sv
	sncxcgHFpzNK3Pj7iA3C+cUocfn3DLBuNgE1iS9fDrOD2CICphIb309hBCliFuhjlJh04xgL
	xFhbiekvNgM1cHBwCthJ9H2qBQkLCzhK7H/QxwpiswioSqyaPxNsJi9Q+Z0b/1ghbEGJH5Pv
	gY1hFtCSWL/zOBOELS+xec1bZpCREgLqEo/+6kKcYCSxZcouVogSEYl9L96BnSMhcI1d4vT6
	n4wQuwQkvk0+xALRKyux6QAzxMOSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcU
	J6UXmegVJ+YWl+al6yXn525ihMTnhB2M9w5YH2JMBlo/kVlKNDkfGN95JfGGxmZGFqYmpsZG
	5pZmpAkrifOqPUoKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDo4izry23deI99u/LSpw6b
	9q+4afOY9eysnUUyVYWzvQV6qo8GP2J8kiEyKcAu4ONOpRP7lz2+vI/hw5GUrrmVz37wX855
	339pX38G+6eQG+/slOI03/7a+FBB7LqiFt/7JZeq6s3NNzJKrxapl2t/tEB4UrLUh3CGp2cO
	unAZKT8LLs88Ne2iEktxRqKhFnNRcSIAoESAA+UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQd2/QnODDP51i1o0L17PZnF54SVW
	iyl/ljNZbJ7/h9Hi8q45bA6sHneu7WHz2D93DbtH35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1WUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMWZM7bjPVPBUuuLrxXeMDYwHxbsYOTkkBEwkbi29yA5h
	i0lcuLeerYuRi0NIYDqjxI2/j6CcX4wSl3/PYAKpYhNQk/jy5TBYh4iAqcTG91MYQYqYBfoY
	JSbdOMYCkhASsJWY/mIzUAMHB6eAnUTfp1qQsLCAo8T+B32sIDaLgKrEqvkzwWbyApXfufGP
	FcIWlPgx+R7YGGYBLYn1O48zQdjyEpvXvGUGGSkhoC7x6K8uxAlGElum7GKFKBGR2PfiHeME
	RqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHP/PpHYwrmyw
	OMQowMGoxMP7YPucICHWxLLiytxDjBIczEoivJ08c4OEeFMSK6tSi/Lji0pzUosPMSYDPTqR
	WUo0OR+YmvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgZHV
	cOEckzOXNHM5HgSfqHRhjgl/mbHgmNYfnwmfo1VnvVd/x5Ugfb0yKaZjgfpfnR7tGQnR5/cy
	7LpayHw/SV/PzjIxfZG23tbNa/lusitJWhn3frcL+FC3jPVj+Sodg7icpfYM06+/644X9rfZ
	2iF/8fHdpVvV5oVG5yzME27vX39a/ZB/jRJLcUaioRZzUXEiAAzcuSRDAwAA
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
 drivers/gpio/gpio-amd8111.c   |    2 +-
 drivers/gpio/gpio-bt8xx.c     |    2 +-
 drivers/gpio/gpio-intel-mid.c |    2 +-
 drivers/gpio/gpio-ml-ioh.c    |    2 +-
 drivers/gpio/gpio-pch.c       |    2 +-
 drivers/gpio/gpio-sodaville.c |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-amd8111.c b/drivers/gpio/gpio-amd8111.c
index 710fafc..94e9992 100644
--- a/drivers/gpio/gpio-amd8111.c
+++ b/drivers/gpio/gpio-amd8111.c
@@ -60,7 +60,7 @@
  * register a pci_driver, because someone else might one day
  * want to register another driver on the same PCI id.
  */
-static DEFINE_PCI_DEVICE_TABLE(pci_tbl) = {
+static const struct pci_device_id pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8111_SMBUS), 0 },
 	{ 0, },	/* terminate list */
 };
diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
index 9dfe36f..c5c356b 100644
--- a/drivers/gpio/gpio-bt8xx.c
+++ b/drivers/gpio/gpio-bt8xx.c
@@ -308,7 +308,7 @@ static int bt8xxgpio_resume(struct pci_dev *pdev)
 #define bt8xxgpio_resume NULL
 #endif /* CONFIG_PM */
 
-static DEFINE_PCI_DEVICE_TABLE(bt8xxgpio_pci_tbl) = {
+static const struct pci_device_id bt8xxgpio_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT848) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT849) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT878) },
diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-intel-mid.c
index be803af..24c2f61 100644
--- a/drivers/gpio/gpio-intel-mid.c
+++ b/drivers/gpio/gpio-intel-mid.c
@@ -275,7 +275,7 @@ static const struct intel_mid_gpio_ddata gpio_tangier = {
 	.chip_irq_type = INTEL_MID_IRQ_TYPE_EDGE,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(intel_gpio_ids) = {
+static const struct pci_device_id intel_gpio_ids[] = {
 	{
 		/* Lincroft */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f),
diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 6da6d76..5c94af3 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -596,7 +596,7 @@ static int ioh_gpio_resume(struct pci_dev *pdev)
 #define ioh_gpio_resume NULL
 #endif
 
-static DEFINE_PCI_DEVICE_TABLE(ioh_gpio_pcidev_id) = {
+static const struct pci_device_id ioh_gpio_pcidev_id[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x802E) },
 	{ 0, }
 };
diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 0fec097..ef7a756 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -518,7 +518,7 @@ static int pch_gpio_resume(struct pci_dev *pdev)
 #endif
 
 #define PCI_VENDOR_ID_ROHM             0x10DB
-static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
+static const struct pci_device_id pch_gpio_pcidev_id[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8043) },
diff --git a/drivers/gpio/gpio-sodaville.c b/drivers/gpio/gpio-sodaville.c
index 88f374a..5d171e0 100644
--- a/drivers/gpio/gpio-sodaville.c
+++ b/drivers/gpio/gpio-sodaville.c
@@ -270,7 +270,7 @@ static void sdv_gpio_remove(struct pci_dev *pdev)
 	kfree(sd);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(sdv_gpio_pci_ids) = {
+static const struct pci_device_id sdv_gpio_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_SDV_GPIO) },
 	{ 0, },
 };
-- 
1.7.10.4


