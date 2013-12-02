Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3LBX3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:29:55 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16542 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3LBX3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:29:50 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-d3-529d17edc247
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        devel@driverdev.osuosl.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 34/39] vme: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:29:48 +0900
Message-id: <003701ceefb6$64918db0$2db4a910$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABQipg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zQ9234nODDN7el7LYc+YXu0Xz4vVs
	FpcXXmK1uLxrDpsDi8e9fYdZPPbPXcPu0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBkPly1i
	Kmjiq3i99ztrA+M37i5GTg4JAROJttUT2SBsMYkL99YD2VwcQgLLGCW6DlxhgymaO+MeK0Ri
	EaPEzfPnmSGcX4wSGybdZgKpYhNQk/jy5TA7iC0iYCqx8f0Uxi5GDg5mgSSJ19/CQcJCArYS
	019sZgIJcwrYSfR9qgUxhQUcJG5NkwepYBFQlXh4sIUZxOYFql60axILhC0o8WPyPTCbWUBL
	Yv3O40wQtrzE5jVvmUHGSAioSzz6qwux30hi87UdUOUiEvtevGMEOVhC4By7xMqlfUwQuwQk
	vk0+xALRKyux6QAzxLeSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXGekV
	J+YWl+al6yXn525ihERk3w7GmwesDzEmA62fyCwlmpwPjOi8knhDYzMjC1MTU2Mjc0sz0oSV
	xHkXPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4/N+01Xn6dTkT2R2cZ03gfGPtLHqg
	V3/lzLcKQanW+3nmPityTzOff4Dd+XyJovJUidwP7SvvKOr4Oq5Pv24g9uxXnKx7tsibX6LB
	WaeuBZuHChf8r7izYvNui7rPB79UFDtMsefqjLht4mw102fBBX/2+5dUXV79OLo+qNH1uWSn
	1Kb2RWlKLMUZiYZazEXFiQDC9FI83gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd234nODDBo38lrsOfOL3aJ58Xo2
	i8sLL7FaXN41h82BxePevsMsHvvnrmH36NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMh8sWMRU08VW83vudtYHxG3cXIyeHhICJxNwZ91ghbDGJC/fW
	s3UxcnEICSxilLh5/jwzhPOLUWLDpNtMIFVsAmoSX74cZgexRQRMJTa+n8LYxcjBwSyQJPH6
	WzhIWEjAVmL6i81MIGFOATuJvk+1IKawgIPErWnyIBUsAqoSDw+2MIPYvEDVi3ZNYoGwBSV+
	TL4HZjMLaEms33mcCcKWl9i85i0zyBgJAXWJR391IfYbSWy+tgOqXERi34t3jBMYhWYhmTQL
	yaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwvD+T3sG4qsHiEKMAB6MS
	D++D7XOChFgTy4orcw8xSnAwK4nwdvLMDRLiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGAq
	yiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxszw/Qe6joTl
	dlSf/G+740dRwKXU5PshTD8OhO45wvjNz6L2moHuodOcf6a+iF8RflWx7l94I8t1XY1FqTzf
	4iZ3xM479LbSPWdakNzmJ99seWSvxOn8i+rzd+JqPWEs/cDs4lWZgz97n5uzMnYdOXRp/1WD
	My/Ue8yiLENYfO9LT6/4qnrtvRJLcUaioRZzUXEiAOzd+8s7AwAA
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
 drivers/vme/boards/vme_vmivme7805.c |    2 +-
 drivers/vme/bridges/vme_ca91cx42.c  |    2 +-
 drivers/vme/bridges/vme_tsi148.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vme/boards/vme_vmivme7805.c b/drivers/vme/boards/vme_vmivme7805.c
index cf74aee..ac42212 100644
--- a/drivers/vme/boards/vme_vmivme7805.c
+++ b/drivers/vme/boards/vme_vmivme7805.c
@@ -27,7 +27,7 @@ static void __iomem *vmic_base;
 
 static const char driver_name[] = "vmivme_7805";
 
-static DEFINE_PCI_DEVICE_TABLE(vmic_ids) = {
+static const struct pci_device_id vmic_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VMIC, PCI_DEVICE_ID_VTIMR) },
 	{ },
 };
diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
index f844857..a06edbf 100644
--- a/drivers/vme/bridges/vme_ca91cx42.c
+++ b/drivers/vme/bridges/vme_ca91cx42.c
@@ -42,7 +42,7 @@ static int geoid;
 
 static const char driver_name[] = "vme_ca91cx42";
 
-static DEFINE_PCI_DEVICE_TABLE(ca91cx42_ids) = {
+static const struct pci_device_id ca91cx42_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TUNDRA, PCI_DEVICE_ID_TUNDRA_CA91C142) },
 	{ },
 };
diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index 9cf8833..16830d8 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -45,7 +45,7 @@ static int geoid;
 
 static const char driver_name[] = "vme_tsi148";
 
-static DEFINE_PCI_DEVICE_TABLE(tsi148_ids) = {
+static const struct pci_device_id tsi148_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TUNDRA, PCI_DEVICE_ID_TUNDRA_TSI148) },
 	{ },
 };
-- 
1.7.10.4


