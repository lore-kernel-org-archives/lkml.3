Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab3K1COI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:14:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47131 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab3K1COF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:14:05 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-6b-5296a6ecc841
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001301ceebdf$628d39e0$27a7ada0$%han@samsung.com>
In-reply-to: <001301ceebdf$628d39e0$27a7ada0$%han@samsung.com>
Subject: [PATCH 2/4] uio: uio_cif: use DEFINE_PCI_DEVICE_TABLE macro
Date: Thu, 28 Nov 2013 11:14:03 +0900
Message-id: <001401ceebdf$826478a0$872d69e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7r32JnCDNFapkhQiG6wImy4nCPggAAAbzQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zfd03y6YFGWy7xm7RvHg9m8XlhZdY
	LS7vmsPmwOyxf+4ado++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKWHtzNXNBF2tFZ99BxgbG
	6SxdjJwcEgImEouWLWSFsMUkLtxbz9bFyMUhJLCMUeLX1Fa4oikdO1ghEtMZJY60TgDrEBL4
	xSjxY3s2iM0moCbx5cthdhBbRMBUYuP7KYxdjBwczAIuEkeniUCU20q0djYygYQ5Bewkbqyw
	BwkLA1UcutkI1skioCqx4noP2HReoPL5E34wQtiCEj8m3wM7h1lAS2L9zuNMELa8xOY1b5lB
	RkoIqEs8+qsLcYCRxNqtF6HKRST2vXjHCHK9hMAudon3516wQOwSkPg2+RALRK+sxKYDzBDf
	SkocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRES
	fb07GG8fsD7EmAy0fiKzlGhyPjB680riDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5Ykpqd
	mlqQWhRfVJqTWnyIkYmDU6qBMdPdumMCa/Kc+3N6T/xTXbRh7/UFYlWNyVPNZ6698iqgZ1Va
	nm50eewas97fe3muLc+WL4z7fPnDgo/f8jjuZL17sCx3eVtnZmWXSpu1rN2/oNsztwVMWCO4
	4zbLmx6Gx8fnHVwkaOXm1hP4ZFJN5vtte79x/yp6cDJe9d6Gki9LbvtON/bo8FRiKc5INNRi
	LipOBAAZCsPq1AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd03y6YFGfzuYLFoXryezeLywkus
	Fpd3zWFzYPbYP3cNu0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZqy9uZq5oIu1orPvIGMD43SWLkZODgkBE4kpHTtYIWwxiQv31rN1MXJxCAlMZ5Q4
	0joBLCEk8ItR4sf2bBCbTUBN4suXw+wgtoiAqcTG91MYuxg5OJgFXCSOThOBKLeVaO1sZAIJ
	cwrYSdxYYQ8SFgaqOHSzEayTRUBVYsX1HrDpvEDl8yf8YISwBSV+TL4HdhqzgJbE+p3HmSBs
	eYnNa94yg4yUEFCXePRXF+IAI4m1Wy9ClYtI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIU
	TS1ILihOSs811CtOzC0uzUvXS87P3cQIju1nUjsYVzZYHGIU4GBU4uGV0JkWJMSaWFZcmXuI
	UYKDWUmEV6EYKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wLSTVxJvaGxiZmRpZGZhZGJu
	TpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2Mmg5rnh252mm5OlVG/75ekURBos2Hkj79
	aUWSTK3Hzz1htvvsELi8dtI2ltMpAnsbEh5v0Td6zPmw/M0NPt7Pnzv9eScXqf/W9GxfvZr5
	n2jtYttTuYlnD91eJs+lYrKz8oRpn/LkhDVdbnWO74I77tQpB9d/mZ5TrvzpS3zV29/nJ3Cf
	4FdSYinOSDTUYi4qTgQALcnywjEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is used to create a struct pci_device_id array.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/uio/uio_cif.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
index 30f533c..07dba37 100644
--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -111,7 +111,7 @@ static void hilscher_pci_remove(struct pci_dev *dev)
 	kfree (info);
 }
 
-static struct pci_device_id hilscher_pci_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(hilscher_pci_ids) = {
 	{
 		.vendor =	PCI_VENDOR_ID_PLX,
 		.device =	PCI_DEVICE_ID_PLX_9030,
-- 
1.7.10.4


