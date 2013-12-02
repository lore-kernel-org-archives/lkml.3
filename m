Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3LBXYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:24:23 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30447 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab3LBXYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:24:21 -0500
X-AuditID: cbfee68f-b7f336d00000481b-28-529d1698d00a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Matt Porter'" <mporter@kernel.crashing.org>,
        "'Alexandre Bounine'" <alexandre.bounine@idt.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 25/39] rapidio: tsi721: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:24:08 +0900
Message-id: <002e01ceefb5$9955d020$cc017060$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABC08A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA90ZYnODDD7tE7bYvqiTyaJ58Xo2
	i8sLL7FaXN41h81i6vnvzA6sHg9PdDJ59LxpYfXYP3cNu0ffllWMHp83yQWwRnHZpKTmZJal
	FunbJXBlHFl1hb3gAGvFifvrGRsYz7J0MXJySAiYSJx98IwZwhaTuHBvPVsXIxeHkMAyRok5
	p34zwxT9mbmcHSKxiFFiensfI4Tzi1Gi/eNUsCo2ATWJL18Os4PYIgKmEhvfTwErYgYZNbt7
	L1iRkICtxPQXm5m6GDk4OAXsJPo+1YKYwgI+Evse1oBUsAioSmxa2AVWzQtUvefZPVYIW1Di
	x+R7YFczC2hJrN95nAnClpfYvOYtM8gYCQF1iUd/dSEuMJI48esSG0SJiMS+F+/ArpEQuMcu
	8WXCKWaIXQIS3yYfYoHolZXYdADqX0mJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuS
	C4qT0ouM9YoTc4tL89L1kvNzNzFCIrV/B+PdA9aHGJOB1k9klhJNzgdGel5JvKGxmZGFqYmp
	sZG5pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYIxv/+F089BL6fgPZt5H
	mD/8Wy63o0fv/4x6tcoHYX9i2DXstUtl3Herz7qy5Vtieuq6/EnMLv5XrszeUH+jbEvXdPvk
	6X1JAsm77c94TNG08Dm5lDfs7keWX1xKew49zSpN/uh2+hqzcfJt97eKdyo4thwIe284YfPU
	qXPjDjimRZ6cEP7s/0MlluKMREMt5qLiRACxP2TQ6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd0ZYnODDKY847fYvqiTyaJ58Xo2
	i8sLL7FaXN41h81i6vnvzA6sHg9PdDJ59LxpYfXYP3cNu0ffllWMHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZhxZdYW94ABrxYn76xkbGM+ydDFyckgImEj8
	mbmcHcIWk7hwbz1bFyMXh5DAIkaJ6e19jBDOL0aJ9o9TmUGq2ATUJL58OQzWISJgKrHx/RSw
	ImaBZYwSs7v3ghUJCdhKTH+xmamLkYODU8BOou9TLYgpLOAjse9hDUgFi4CqxKaFXWDVvEDV
	e57dY4WwBSV+TL4HdhyzgJbE+p3HmSBseYnNa94yg4yREFCXePRXF+ICI4kTvy6xQZSISOx7
	8Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4Dz6R2
	MK5ssDjEKMDBqMTD+2D7nCAh1sSy4srcQ4wSHMxKIrydPHODhHhTEiurUovy44tKc1KLDzEm
	Az06kVlKNDkfmKLySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNT
	qoGx5kd876vpXaqzIn7/c7Ps+3Nzx+HoZsPWTOO6PxbaBvEh90QfT71/cNYvNxnJnDP+X/JY
	KrTP1mdOMD62PT1UfVVwj80z/Q33zrEpbn4oFXw9+Q1Thq87y+//AsvXtvwW3JKs9iOaw01K
	J/dbS4dWZt6Wbp0/VxevYWb5GHNjhWQw83vDrzFKLMUZiYZazEXFiQA4U3AFRwMAAA==
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
 drivers/rapidio/devices/tsi721.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index ff7cbf2..eb9f012 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -2497,7 +2497,7 @@ err_exit:
 	return err;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(tsi721_pci_tbl) = {
+static const struct pci_device_id tsi721_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_IDT, PCI_DEVICE_ID_TSI721) },
 	{ 0, }	/* terminate list */
 };
-- 
1.7.10.4


