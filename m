Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaLCQOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:14:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26299 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaLCQIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:08:45 -0500
X-AuditID: cbfee61a-f79c06d000004e71-94-547f3569e6e8
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        devicetree@vger.kernel.org
Subject: [PATCH/RFC v9 09/19] of: Add Skyworks Solutions, Inc. vendor prefix
Date: Wed, 03 Dec 2014 17:06:44 +0100
Message-id: <1417622814-10845-10-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd1M0/oQg53tFhYbZ6xntTi6cyKT
	xfwj51gt+t8sZLU492olo0Xv1eeMFmeb3rBbXN41h81i65t1jBY9G7ayWiy9fpHJ4u6po2wW
	E6avZbFo3XuE3WL3rqesFofftLNanNm/ks1B0GPNvDWMHpf7epk8ds66y+6xcvkXNo/DXxey
	eGxa1cnmsWf+D1aPvi2rGD1WrP7O7vF5k1wAVxSXTUpqTmZZapG+XQJXxvmH6gUHOSomrvvM
	2MC4hr2LkZNDQsBEouXraxYIW0ziwr31bCC2kMB0RonVp527GLmA7HYmiZd/fzKDJNgEDCV+
	vnjN1MXIwSEiEC1x6Vg9SA2zwF0miXkbvjGC1AgL+EicePSHFcRmEVCVWHpzIdgCXgFPiUUn
	P7GA9EoIKEjMmWQDEuYECj/9cZ8dJCwk4CFxcKL/BEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL
	89L1kvNzNzGCg/yZ1A7GlQ0WhxgFOBiVeHgt4upChFgTy4orcw8xSnAwK4nwPvsGFOJNSays
	Si3Kjy8qzUktPsQozcGiJM5742ZuiJBAemJJanZqakFqEUyWiYNTqoGx7rjmlsw9Z4OKq6XT
	+jviecQ6l8We3BKzRCnB5kXnEe5u0wpNt9Wx3BnCpQE768TeBh35xrm17XyuYqOHy74n0of2
	ZEWVTb+7sf3XwiqFF23ql2Z/uKTI8W2ipNum1YE3JmUf91GfsPhgW9n9pi+5RzpzzJbNdL/7
	rlHYdG1qr85V3nfvisSVWIozEg21mIuKEwHkkK9LbgIAAA==
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
Cc: <devicetree@vger.kernel.org>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index c177cd7..3006825 100644
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

