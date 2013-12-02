Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab3LBXNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:13:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11462 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3LBXNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:13:15 -0500
X-AuditID: cbfee691-b7f666d0000048b0-02-529d140ad32d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Samuel Iglesias Gonsalvez'" <siglesias@igalia.com>,
        industrypack-devel@lists.sourceforge.net
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 13/39] ipack: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:13:14 +0900
Message-id: <002201ceefb4$13b12010$3b136030$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAqhZw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zY10ukblBBovPqlk0L17PZrHmg7zF
	5YWXWC0u75rDZnFoqboDq8eE2d1sHvvnrmH32L3gM5NH35ZVjB6fN8kFsEZx2aSk5mSWpRbp
	2yVwZfTM3spS0MZW0bmrvIFxAmsXIyeHhICJxNt9N9ggbDGJC/fWA9lcHEICyxglPq2aAlf0
	6HMnK0RiEaPEra4NLBDOL0aJX3++MoNUsQmoSXz5cpgdxBYRMJXY+H4KI0gRM8io5RcXsoAk
	hARsJaa/2MzUxcjBwSlgJ9H3qRYkLCzgJNHd9ZcRxGYRUJWYcns2C0gJL1D50+0+IGFeAUGJ
	H5PvgU1hFtCSWL/zOBOELS+xec1bZpByCQF1iUd/dSEuMJJY/vIII0SJiMS+F+/ArpEQuMcu
	Men7Z3aIVQIS3yYfYoHolZXYdIAZ4l9JiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVML
	kguKk9KLTPWKE3OLS/PS9ZLzczcxQmJ04g7G+wesDzEmA62fyCwlmpwPjPG8knhDYzMjC1MT
	U2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCs5ZHdkXHVbd/+HTvD
	dd5b7TTha1CePTXupmX9L9+dramXH2vNLAleuUTs77rbZ7NiXqUYabdo1nx1Kp+9/finqmls
	WUuU/zg1+U40Pvj6esSve1PPfWFYtftEWkHx/M3iu8NP7RRZVHxRLvYrB+ev6qcXebwjvjpP
	///WxXXd3pbsGTe1XgTtUWIpzkg01GIuKk4EAFoNu1fnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jAV0ukblBBrOuK1k0L17PZrHmg7zF
	5YWXWC0u75rDZnFoqboDq8eE2d1sHvvnrmH32L3gM5NH35ZVjB6fN8kFsEY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
	6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWb0zN7KUtDGVtG5q7yBcQJrFyMnh4SAicSjz51Q
	tpjEhXvr2boYuTiEBBYxStzq2sAC4fxilPj15yszSBWbgJrEly+H2UFsEQFTiY3vpzCCFDEL
	LGOUWH5xIQtIQkjAVmL6i81MXYwcHJwCdhJ9n2pBwsICThLdXX8ZQWwWAVWJKbdns4CU8AKV
	P93uAxLmFRCU+DH5HtgUZgEtifU7jzNB2PISm9e8ZQYplxBQl3j0VxfiAiOJ5S+PMEKUiEjs
	e/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOAM+k
	dzCuarA4xCjAwajEw/tg+5wgIdbEsuLK3EOMEhzMSiK8nTxzg4R4UxIrq1KL8uOLSnNSiw8x
	JgP9OZFZSjQ5H5ic8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmD
	U6qB0bml5pjozDZpu+01574nbzbk57Fh/PhR/cWCSO+d8oFBH9hfWFoKOe/bF++wdOb+cuVm
	z917eab49K9u2NRxxqIocrtihB9/xkOXozk9b3Q4PWc/DRKvs15z68tS/mVqC0/PD3jLcbzk
	/N6jtRyHDxqHFFyOZTfoDf/9Lc5mqbjBonfHNq/zV2Ipzkg01GIuKk4EAAd0jD5EAwAA
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
 drivers/ipack/carriers/tpci200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index c276fde..de5e321 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -618,7 +618,7 @@ static void tpci200_pci_remove(struct pci_dev *dev)
 	__tpci200_pci_remove(tpci200);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(tpci200_idtable) = {
+static const struct pci_device_id tpci200_idtable[] = {
 	{ TPCI200_VENDOR_ID, TPCI200_DEVICE_ID, TPCI200_SUBVENDOR_ID,
 	  TPCI200_SUBDEVICE_ID },
 	{ 0, },
-- 
1.7.10.4


