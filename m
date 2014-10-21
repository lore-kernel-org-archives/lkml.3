Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaJUF6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:58:15 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51815 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbaJUF6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:58:11 -0400
From: Ankit Jindal <ankit.jindal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Ankit Jindal <ankit.jindal@linaro.org>
Subject: [PATCH v3 1/6] uio: code style cleanup
Date: Tue, 21 Oct 2014 11:26:45 +0530
Message-Id: <1413871011-4101-2-git-send-email-ankit.jindal@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org>
References: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the indentation of switch-case block in uio driver.

Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 drivers/uio/uio.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a673e5b..97e6444 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -706,13 +706,13 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 	}
 
 	switch (idev->info->mem[mi].memtype) {
-		case UIO_MEM_PHYS:
-			return uio_mmap_physical(vma);
-		case UIO_MEM_LOGICAL:
-		case UIO_MEM_VIRTUAL:
-			return uio_mmap_logical(vma);
-		default:
-			return -EINVAL;
+	case UIO_MEM_PHYS:
+		return uio_mmap_physical(vma);
+	case UIO_MEM_LOGICAL:
+	case UIO_MEM_VIRTUAL:
+		return uio_mmap_logical(vma);
+	default:
+		return -EINVAL;
 	}
 }
 
-- 
1.7.9.5

