Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbbAIPYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:24:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:23431 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892AbbAIPY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:24:29 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-69-54aff2aba9c1
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v10 11/19] of: Add Skyworks Solutions, Inc. vendor prefix
Date: Fri, 09 Jan 2015 16:23:01 +0100
Message-id: <1420816989-1808-12-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd3Vn9aHGBzrkLbYOGM9q8XRnROZ
	LOYfOcdq0f9mIavFuVcrGS16rz5ntDjb9Ibd4vKuOWwWW9+sY7To2bCV1WLp9YtMFndPHWWz
	mDB9LYtF694j7Ba7dz1ltTj8pp3V4sz+lWwOgh5r5q1h9Ljc18vksXPWXXaPlcu/sHkc/rqQ
	xWPTqk42jz3zf7B69G1ZxeixYvV3do/Pm+QCuKK4bFJSczLLUov07RK4Mrq2/WIpmM9RsW3R
	ctYGxl72LkZODgkBE4nWRfOYIWwxiQv31rN1MXJxCAlMZ5TYffw0E4TTziTx80sTWAebgKHE
	zxevgRIcHCIC0RKXjtWD1DALLGWWmN55iwWkRljAV6Jv8w42EJtFQFVi3YSfrCD1vAIeEhu6
	I0BMCQEFiTmTbEBMTqBoy28nEFNIwF3izVXDCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXr
	JefnbmIEB/kz6R2MqxosDjEKcDAq8fBukFsfIsSaWFZcmXuIUYKDWUmEt2EzUIg3JbGyKrUo
	P76oNCe1+BCjNAeLkjivkn1biJBAemJJanZqakFqEUyWiYNTqoEx+m6oWpFa6zPFa7NnzGpn
	ijNinlb5xlPvw4ZT1g4dQZl9RSsKCiVSVT9ZpQWtfxo340h2hQiHTJ2iZVTcy8y1EnXPnii9
	f5RlpHnk6e9TAiGhalzTJDWvXezx71m6hEFsYVKcrcGXLpfbUhxFItYldted+C8GpNiHc8ms
	u86u8+CEr7C8ghJLcUaioRZzUXEiAEfA+BBuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "skyworks" as the vendor prefix for the Skyworks Solutions, Inc.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index d8d18c0..b27fe1c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -137,6 +137,7 @@ ricoh	Ricoh Co. Ltd.
 rockchip	Fuzhou Rockchip Electronics Co., Ltd
 samsung	Samsung Semiconductor
 sandisk	Sandisk Corporation
+skyworks	Skyworks Solutions, Inc.
 sbs	Smart Battery System
 schindler	Schindler
 seagate	Seagate Technology PLC
-- 
1.7.9.5

