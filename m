Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3LBXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:25:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:15860 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3LBXZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:25:21 -0500
X-AuditID: cbfee690-b7f126d00000418c-f4-529d16e0ee1e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Mark Brown'" <broonie@kernel.org>, linux-spi@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 27/39] spi: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:25:19 +0900
Message-id: <003001ceefb5$c418c600$4c4a5200$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABGpoQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zQ90HYnODDDZdYraY+vAJm0Xz4vVs
	FpcXXmK1uLxrDptF48eb7A6sHptWdbJ57J+7ht2jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mnr+sxYs56uYMWU3YwNjF08XIyeHhICJxPMp19ghbDGJC/fWs4HYQgLLGCWWrkmEqdn87x9Q
	nAsoPp1Rou/7UhYI5xejxIMNt8C62QTUJL58OQxmiwiYSmx8P4URxGYWaGGUeN8gDzHVVmL6
	i81MXYwcHJwCdhJ9n2pBwsICDhLbX68DK2cRUJX4dPA3M4jNC1S+b9Z9VghbUOLH5HssECO1
	JNbvPM4EYctLbF7zlhlkpISAusSjv7oQFxhJ3D91kx2iRERi34t3jCAnSwhcYpdYvfk1C8Qu
	AYlvkw+xQPTKSmw6wAzxr6TEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UUm
	esWJucWleel6yfm5mxghsTlhB+O9A9aHGJOB1k9klhJNzgfGdl5JvKGxmZGFqYmpsZG5pRlp
	wkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MEblnH6xMOmg4oajB4u/hU+9tvlX
	2/Zd/KdMJ2omhoTITmYqsrv9SNu04mfwhoX/dcr7rgiaHV7FIhX96Q977e7SgOcSRSW+/z+q
	Hvnw+pDVqwvbv6zo1bk079FO1uzyhbklp48vEpHv3VloJn1li/iLOVvudO5Md/v+8afNWYtg
	PqlDe27r/E1UYinOSDTUYi4qTgQASzDpTeMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd37YnODDLoe21hMffiEzaJ58Xo2
	i8sLL7FaXN41h82i8eNNdgdWj02rOtk89s9dw+7Rt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYR1jBk9/1kLlvNVzJiym7GBsYuni5GTQ0LARGLzv39sELaY
	xIV764FsLg4hgemMEn3fl7JAOL8YJR5suMUOUsUmoCbx5cthMFtEwFRi4/spjCA2s0ALo8T7
	BnkQW0jAVmL6i81MXYwcHJwCdhJ9n2pBwsICDhLbX68DK2cRUJX4dPA3M4jNC1S+b9Z9Vghb
	UOLH5HssECO1JNbvPM4EYctLbF7zlhlkpISAusSjv7oQFxhJ3D91kx2iRERi34t3jBMYhWYh
	mTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw7D+T2sG4ssHiEKMA
	B6MSD++D7XOChFgTy4orcw8xSnAwK4nwdvLMDRLiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHk
	fGBayiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxoBPfzbY
	RL7/+lBw96Kb855ODlil1Fcjc6PErPPOe5/Tr2dUVc1rnT0nf1ZEn73K1SSrvHNsL25fUdCr
	/NPC3GOr9D57VkjR5iRF4xzXl2biPJF17Eei759541EtpZAV4HjGM4751Pt1m5OkXmv4XdLX
	id32avaZ0vfz+cSz+wQuPNDSNGJarMRSnJFoqMVcVJwIAPdY1mZBAwAA
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
 drivers/spi/spi-dw-pci.c       |    2 +-
 drivers/spi/spi-pxa2xx-pci.c   |    2 +-
 drivers/spi/spi-topcliff-pch.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-dw-pci.c b/drivers/spi/spi-dw-pci.c
index 66fa995..f7be4be 100644
--- a/drivers/spi/spi-dw-pci.c
+++ b/drivers/spi/spi-dw-pci.c
@@ -148,7 +148,7 @@ static int spi_resume(struct pci_dev *pdev)
 #define spi_resume	NULL
 #endif
 
-static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
+static const struct pci_device_id pci_ids[] = {
 	/* Intel MID platform SPI controller 0 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0800) },
 	{},
diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index 74bc187..3f006d3 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -62,7 +62,7 @@ static void ce4100_spi_remove(struct pci_dev *dev)
 	platform_device_unregister(pdev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(ce4100_spi_devices) = {
+static const struct pci_device_id ce4100_spi_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2e6a) },
 	{ },
 };
diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 4461313..338fc11 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -217,7 +217,7 @@ struct pch_pd_dev_save {
 	struct pch_spi_board_data *board_dat;
 };
 
-static DEFINE_PCI_DEVICE_TABLE(pch_spi_pcidev_id) = {
+static const struct pci_device_id pch_spi_pcidev_id[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_GE_SPI),    1, },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_SPI), 2, },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_SPI), 1, },
-- 
1.7.10.4


