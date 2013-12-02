Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3LBX0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:26:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13767 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3LBX0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:26:39 -0500
X-AuditID: cbfee68f-b7f336d00000481b-4a-529d172dc32f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Jiri Slab'" <jslaby@suse.cz>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 29/39] tty: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:26:37 +0900
Message-id: <003201ceefb5$f283b540$d78b1fc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABJW/g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zQ11d8blBBrs7LS2aF69ns7i88BKr
	xeffu1gtLu+aw+bA4rF/7hp2j74tqxg9ziw4wu7xeZNcAEsUl01Kak5mWWqRvl0CV8a0Xy9Z
	CubwVTw8uJ25gbGVp4uRg0NCwETi66GSLkZOIFNM4sK99WxdjFwcQgLLGCWefHjCBJEwkXg8
	/wkrRGI6o8TDDROYIZxfjBJnF39gAaliE1CT+PLlMDuILSJgKrHx/RRGEJtZIEVi98P7zCC2
	kICtxPQXm5lANnMK2En0faoFMYUFHCT6T6uAmCwCqhKNZwpAinmBiud8uMYIYQtK/Jh8jwVi
	oJbE+p3HmSBseYnNa94yQ7yiLvHory6IKSJgJLHknQ5EhYjEvhfvGEHulRC4xC6x9MMksJEs
	AgIS3yYfYoFolZXYdIAZ4llJiYMrbrBMYJSYhWTxLCSLZyFZPAvJigWMLKsYRVMLkguKk9KL
	jPWKE3OLS/PS9ZLzczcxQqKxfwfj3QPWhxiTgdZPZJYSTc4HRnNeSbyhsZmRhamJqbGRuaUZ
	acJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDU/huqk2iZO61zy7L9J+QVHN49
	u7pr2xzWDX+/C11auThP+BlbPMthli+tD27nPF494aq0evXk3A3nVoXNs21WeiYcbix7/d72
	XXXK/sVLPhwyvf/u3Pz8kujyx8Jfv91pDuP4KtJ3q+JkZ8fp9N0xsz4wPGW9Ihj/7DbzEpEA
	UdmMh6frPS/9VWIpzkg01GIuKk4EAPI8Vv3cAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQV1d8blBBtd3mVo0L17PZnF54SVW
	i8+/d7FaXN41h82BxWP/3DXsHn1bVjF6nFlwhN3j8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMab9eshTM4at4eHA7cwNjK08XIyeHhICJxOP5T1ghbDGJC/fW
	s3UxcnEICUxnlHi4YQIzhPOLUeLs4g8sIFVsAmoSX74cZgexRQRMJTa+n8IIYjMLpEjsfnif
	GcQWErCVmP5iM1MXIwcHp4CdRN+nWhBTWMBBov+0CojJIqAq0XimAKSYF6h4zodrjBC2oMSP
	yfdYIAZqSazfeZwJwpaX2LzmLTNIq4SAusSjv7ogpoiAkcSSdzoQFSIS+168Y5zAKDQLyaBZ
	SAbNQjJoFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/2Z1A7GlQ0WhxgFOBiV
	eHgfbJ8TJMSaWFZcmXuIUYKDWUmEt5NnbpAQb0piZVVqUX58UWlOavEhxmSgNycyS4km5wMT
	UV5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MLZ8L4nSeZNu
	Fnq7qIszasVeNeOS5gseT+1mS1ttj1HUfRrgct/C6MDeCY57Vxp+Wht27DNHlmTOpoPrHvwq
	urP/Q5+l5Am3uQyTD//dP3eW5KT3N5eys28Tt32zTupb6j69/+lyNg8inlfp/nsQe0m1eyV7
	99y4srNRcrNnSPtunv9bpKLmBIcSS3FGoqEWc1FxIgDW1nlFOgMAAA==
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
 drivers/tty/rocket.c          |    2 +-
 drivers/tty/serial/pch_uart.c |    2 +-
 drivers/tty/serial/rp2.c      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 354564e..383c4c7 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -1744,7 +1744,7 @@ static void rp_flush_buffer(struct tty_struct *tty)
 
 #ifdef CONFIG_PCI
 
-static DEFINE_PCI_DEVICE_TABLE(rocket_pci_ids) = {
+static const struct pci_device_id rocket_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RP, PCI_DEVICE_ID_RP4QUAD) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_RP, PCI_DEVICE_ID_RP8OCTA) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_RP, PCI_DEVICE_ID_URP8OCTA) },
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 0aa2b52..77b8166 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1907,7 +1907,7 @@ static int pch_uart_pci_resume(struct pci_dev *pdev)
 #define pch_uart_pci_resume NULL
 #endif
 
-static DEFINE_PCI_DEVICE_TABLE(pch_uart_pci_id) = {
+static const struct pci_device_id pch_uart_pci_id[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8811),
 	 .driver_data = pch_et20t_uart0},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8812),
diff --git a/drivers/tty/serial/rp2.c b/drivers/tty/serial/rp2.c
index 328d6de..056f91b 100644
--- a/drivers/tty/serial/rp2.c
+++ b/drivers/tty/serial/rp2.c
@@ -810,7 +810,7 @@ static void rp2_remove(struct pci_dev *pdev)
 	rp2_remove_ports(card);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(rp2_pci_tbl) = {
+static const struct pci_device_id rp2_pci_tbl[] = {
 
 	/* RocketPort INFINITY cards */
 
-- 
1.7.10.4


