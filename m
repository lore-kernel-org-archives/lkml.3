Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab3K1CNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:13:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24857 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab3K1CNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:13:12 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-a2-5296a6b66b8c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/4] uio: uio_aec: use DEFINE_PCI_DEVICE_TABLE macro
Date: Thu, 28 Nov 2013 11:13:10 +0900
Message-id: <001301ceebdf$628d39e0$27a7ada0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7r32JnCDNFapkhQiG6wImy4nCPgg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t8zI91ty6YFGVw5amjRvHg9m8XlhZdY
	LS7vmsPmwOyxf+4ado++LasYPT5vkgtgjuKySUnNySxLLdK3S+DK2PR8DVvBUZaKJ//ZGxiv
	M3cxcnBICJhIPOiM72LkBDLFJC7cW8/WxcjFISSwjFFi24XXrBAJE4nnHReYIRLTGSXe/m5m
	hXB+MUr8uTyVDaSKTUBN4suXw+wgtoiAqcTG91MYQTYwC7hIHJ0mAhIWBjI3P77MChJmEVCV
	+LGkEsTkFbCVeHzSGqSCV0BQ4sfkeywgNrOAlsT6nceZIGx5ic1r3kKdrC7x6K8uxB49iW+X
	j7BClIhI7HvxjhHkMAmBZewSm9f9BTuMRUBA4tvkQywQvbISmw4wQ3wlKXFwxQ2WCYxis5Bs
	noVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkgk9e5gvH3A+hBjMtD6
	icxSosn5wEjMK4k3NDYzsjA1MTU2Mrc0I01YSZw36WFSkJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbGFpelCyX7dZ+nGPgcY7vq3c2xWUzNnm1t/4xj5b3PDB4dOVz3UyKdTdapwM6E+dbt
	h1HLf1RvyDhRdMhik9CD1V4srXtnSYY+Yz2Q/NZvyaOp1XNUbjHeSSnYl1GV1rBx4/xtqdud
	/s9tW7jq5vG/9dq24jcaQxduuh6Rs44rYANjThXf7Z5AJZbijERDLeai4kQAKFzXILoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoO62ZdOCDD5P1LNoXryezeLywkus
	Fpd3zWFzYPbYP3cNu0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZmx6voat4ChLxZP/7A2M15m7GDk5JARMJJ53XICyxSQu3FvP1sXIxSEkMJ1R4u3v
	ZlYI5xejxJ/LU9lAqtgE1CS+fDnMDmKLCJhKbHw/hbGLkYODWcBF4ug0EZCwMJC5+fFlVpAw
	i4CqxI8llSAmr4CtxOOT1iAVvAKCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZpFxCQF3i0V9d
	iD16Et8uH2GFKBGR2PfiHeMERoFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtc
	mpeul5yfu4kRHKnPpHcwrmqwOMQowMGoxMMroTMtSIg1say4MvcQowQHs5IIr0IxUIg3JbGy
	KrUoP76oNCe1+BBjMtCbE5mlRJPzgUkkryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6Ykl
	qdmpqQWpRTBbmDg4pRoYFU/OyPB99W6L2ZGFCoyrTvuk7FyxMHniUfkLG/pzzmzSvP1bv3vu
	9OOHTv2qSVGXq0kQ3xHlsGWaw9loMe8d+5VeRH8uZG83UWFk496YXfJz/uctl14dyvQzq+Tb
	aFET9fnSksWMt3dc/9ZZJ3aAQ+hqi0AkJ3+Q79/rPI9K6p7UbOIO0Zv0SYmlOCPRUIu5qDgR
	AJSLDEMYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is used to create a struct pci_device_id array.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/uio/uio_aec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_aec.c b/drivers/uio/uio_aec.c
index 1549fab..c06f800 100644
--- a/drivers/uio/uio_aec.c
+++ b/drivers/uio/uio_aec.c
@@ -45,7 +45,7 @@
 
 #define MAILBOX			0x0F
 
-static struct pci_device_id ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AEC, PCI_DEVICE_ID_AEC_VITCLTC), },
 	{ 0, }
 };
-- 
1.7.10.4


