Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3JHNrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:47:07 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:63405 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3JHNrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:47:04 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree@vger.kernel.org,
        mark.rutland@arm.com, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2] Documentation: add moxa vendor prefix
Date: Tue,  8 Oct 2013 15:46:47 +0200
Message-Id: <1381240007-9321-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1381237000-8398-1-git-send-email-jonas.jensen@gmail.com>
References: <1381237000-8398-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add moxa vendor prefix.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Changes since v1:
    
    1. use the correct vendor name "Moxa Technologies Co., Ltd."
    
    Applies to next-20130927

 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 2956800..3b9e056 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -40,6 +40,7 @@ marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
 microchip	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
+moxa	Moxa Technologies Co., Ltd.
 national	National Semiconductor
 nintendo	Nintendo
 nvidia	NVIDIA
-- 
1.8.2.1

