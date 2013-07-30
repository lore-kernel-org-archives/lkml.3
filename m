Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab3G3JUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:20:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12964 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab3G3JUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:20:50 -0400
X-AuditID: cbfee691-b7fef6d000002d62-6d-51f785700bd0
From: Jingoo Han <jg1.han@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] Driver core: Add accessor for device tree node
Date: Tue, 30 Jul 2013 18:20:47 +0900
Message-id: <007601ce8d06$13dbb890$3b9329b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6NBYOmTcp9nI+FTGyWGqKoa5RWfw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zI92C1u+BBr+ei1vMWb+GzWLqwyds
	FvOPnGO1OPBnB6NF8+L1bBaXF15itbi8aw6bxeEVB5gcODwWfL7C7rFpVSebx51re9g8Tsz4
	zeKxf+4ado++LasYPT5vkgtgj+KySUnNySxLLdK3S+DK+HDnCXvBNdaKdSfVGxgvsXQxcnJI
	CJhITL1yjQnCFpO4cG89WxcjF4eQwDJGif51L4GKOMCKFu3hg4hPZ5RYvHcnO4Tzi1Fi7vG9
	rCDdbAJqEl++HGYHsUUEjCX6z84CK2IW+M8osbfnMjNIQljAXuLJr/+MIDaLgKrEtrWnwRp4
	BSwl5l+7zwhhC0r8mHwP7DxmAS2J9TuPM0HY8hKb17xlhjhVQWLH2deMEMv0JBrvrIWqF5HY
	9+IdI8hiCYG37BKf1u1kg1gmIPFt8iGod2QlNh2AmiMpcXDFDZYJjGKzkKyehWT1LCSrZyFZ
	sYCRZRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSLRO3MF4/4D1IcZkoPUTmaVEk/OB0Z5X
	Em9obGZkYWpiamxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsYzf6ae
	P7e/oGN1aNX8Aw9qY8qWKU2do+k60cYnM23NkwNCl/yWbnq79cv3GTGNNeYRm3sKN1l9ervM
	dWprgjf7u98np8h+Oda4QqaQvbMqrdKU/7j1yqiJVaIbBO+bKz1lZns28evmu+vOnXfruGW5
	wE5E4nBFc+XHALOODC6uylWb7ux1ytipxFKckWioxVxUnAgAD/wLJ+wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jQd2C1u+BBh8uClvMWb+GzWLqwyds
	FvOPnGO1OPBnB6NF8+L1bBaXF15itbi8aw6bxeEVB5gcODwWfL7C7rFpVSebx51re9g8Tsz4
	zeKxf+4ado++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBX
	UshLzE21VXLxCdB1y8wBOktJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjH
	mPHhzhP2gmusFetOqjcwXmLpYuTgkBAwkVi0h6+LkRPIFJO4cG89WxcjF4eQwHRGicV7d7JD
	OL8YJeYe38sKUsUmoCbx5cthdhBbRMBYov/sLLAiZoH/jBJ7ey4zgySEBewlnvz6zwhiswio
	SmxbexqsgVfAUmL+tfuMELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGWGOElBYsfZ14wQy/Qk
	Gu+shaoXkdj34h3jBEaBWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJEZwKnknvYFzVYHGIUYCDUYmHd0PBt0Ah1sSy4srcQ4wSHMxKIrwsN4BCvCmJlVWpRfnx
	RaU5qcWHGJOBPp3ILCWanA9MU3kl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0t
	SC2C2cLEwSnVwLiGN+jjhZlXmJxnX1JYIG3+TnOGa9TBPZ+PSe+v2dK2L+z9jc2vlpXyKp+4
	vaBeImTvq0t/A5c/dIh7orS4aEagzadLt7v8T5XY56z5xnH5f+i7jPw5fq0/lu8IbmveNJVj
	9XclhopeqXe3VV9xGS2S7Ug+ZjyrpX/Z/ra1yrnCC1SlW1ot9mspsRRnJBpqMRcVJwIAlpLr
	l0kDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the wrapper function for retrieving device tree node instead of
accessing dev->of_node directly.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 include/linux/device.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index 22b546a..4faaa51 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -917,6 +917,11 @@ static inline void *dev_get_platdata(const struct device *dev)
 	return dev->platform_data;
 }
 
+static inline void *dev_get_of_node(const struct device *dev)
+{
+	return dev->of_node;
+}
+
 /*
  * Manual binding of a device to driver. See drivers/base/bus.c
  * for information on use.
-- 
1.7.10.4


