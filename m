Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3LBXbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:31:01 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16773 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab3LBXa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:30:59 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-c3-529d182d3c04
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 36/39] xen: pciback: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:30:53 +0900
Message-id: <003901ceefb6$8ae65400$a0b2fc00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABTJ/A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA11diblBBu/aVCyaF69ns7i88BKr
	xbLFTxktLu+aw2bxfctkJgdWj/1z17B7HP5whcXj49NbLB59W1YxenzeJBfAGsVlk5Kak1mW
	WqRvl8CVMX+pUsF21oq/064zNTAeZuli5OSQEDCRaN5wF8oWk7hwbz1bFyMXh5DAMkaJTzPn
	s8IUvZ3bxQSRWMQo8XTDUkYI5xejxNUll8Gq2ATUJL58OcwOYosImEpsfD8FrIhZYBajxNlN
	3YwgCSEBW4npLzYDjeLg4BSwk+j7VAsSFhbwlNi+5yQbiM0ioCqx70MLM4jNC1S+rL+RCcIW
	lPgx+R7YqcwCWhLrdx5ngrDlJTavecsMMlJCQF3i0V9diBOMJDrPn4UqF5HY9+Id2DkSAvfY
	Jaa1/obaJSDxbfIhFoheWYlNB5ghHpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUg
	uaA4Kb3ISK84Mbe4NC9dLzk/dxMjJFL7djDePGB9iDEZaP1EZinR5HxgpOeVxBsamxlZmJqY
	GhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsYVRWdu8DFGqGhXz39k
	GbaqlftGvCRrdvsuTpfjYdXvXxs9lzP+za2o9G930fOGukny8eoeGTd/7Wo6cm/3z/w8rgcf
	NQxE4j8LuHK3XWe016l7Y99W91MyxHX9ystpLYHRbqx/9Ex/fV7/gWuTwONvCfvc2aNDfSSO
	Tth49K/7v3kTvBap9yixFGckGmoxFxUnAgCd6w7G6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV1diblBBquXK1g0L17PZnF54SVW
	i2WLnzJaXN41h83i+5bJTA6sHvvnrmH3OPzhCovHx6e3WDz6tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWP+UqWC7awVf6ddZ2pgPMzSxcjJISFgIvF2
	bhcThC0mceHeerYuRi4OIYFFjBJPNyxlhHB+MUpcXXKZFaSKTUBN4suXw+wgtoiAqcTG91PA
	ipgFZjFKnN3UzQiSEBKwlZj+YjPQWA4OTgE7ib5PtSBhYQFPie17TrKB2CwCqhL7PrQwg9i8
	QOXL+huZIGxBiR+T74FdxyygJbF+53EmCFteYvOat8wgIyUE1CUe/dWFOMFIovP8WahyEYl9
	L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFp4JnU
	DsaVDRaHGAU4GJV4eB9snxMkxJpYVlyZe4hRgoNZSYS3k2dukBBvSmJlVWpRfnxRaU5q8SHG
	ZKBHJzJLiSbnA1NUXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFw
	SjUwOm6M1zvxfGpy/8Ra/XuVNfPZp2bOn9JhtS3o7t8DjFc/Mx3Z66aS0dxVnselvNcg6qqF
	aVds4O/HHSaBUx8nWhn/Xx5p4jHnkPRHjue2ptdSvvb8PrNwua+82SpfQ6fDx3mmrV99eNq1
	Lft/OW98fulDkkh6nme1w5P3fPk6FoIaWopXhd9zK7EUZyQaajEXFScCABGMnehHAwAA
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
 drivers/xen/xen-pciback/pci_stub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 62fcd48..08d9369 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -564,7 +564,7 @@ static void pcistub_remove(struct pci_dev *dev)
 	}
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pcistub_ids) = {
+static const struct pci_device_id pcistub_ids[] = {
 	{
 	 .vendor = PCI_ANY_ID,
 	 .device = PCI_ANY_ID,
-- 
1.7.10.4


