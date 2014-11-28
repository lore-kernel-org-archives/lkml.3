Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaK1JVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:21:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53595 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaK1JVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:21:05 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-a2-54783e7edb6c
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH/RFC v8 13/14] of: Add Skyworks Solutions, Inc. vendor prefix
Date: Fri, 28 Nov 2014 10:18:05 +0100
Message-id: <1417166286-27685-14-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jQd06u4oQg2szVSw2zljPanF050Qm
	i/lHzrFa9L9ZyGpx7tVKRoveq88ZLc42vWG3uLxrDpvF1jfrGC16NmxltVh6/SKTxd1TR9ks
	Jkxfy2LRuvcIu8XuXU9ZLQ6/aWe1OLN/JZuDoMeaeWsYPS739TJ57Jx1l91j5fIvbB6Hvy5k
	8di0qpPNY8/8H6wefVtWMXqsWP2d3ePzJrkArigum5TUnMyy1CJ9uwSujM2XlrIVHOKomLju
	M2MD4xr2LkZODgkBE4l5Bx+wQthiEhfurWfrYuTiEBKYziixf08fO4TTziSxec8HsA42AUOJ
	ny9eM3UxcnCICERLXDpWD1LDLLCcWeLFlyNMIDXCAj4SE+/cBZvKIqAqce7hPzCbV8BTou/R
	BTaQXgkBBYk5k2xAwpxA4bmf17KAhIUEPCQWvUqZwMi7gJFhFaNoakFyQXFSeq6RXnFibnFp
	Xrpecn7uJkZwoD+T3sG4qsHiEKMAB6MSD+/Pf+UhQqyJZcWVuYcYJTiYlUR4T30FCvGmJFZW
	pRblxxeV5qQWH2KU5mBREue9cTM3REggPbEkNTs1tSC1CCbLxMEp1cConWTrc3/rrF++uWx8
	kms7LZOkt3IdmHH4/eHZnQ0zvJ3WKt6OX2i0a67fjBprptKiVqE5jOd3nmNe81554jWptdXN
	9/QFstYLSV6+mPJaYs6eHR8UTd7EbFCyS1d+/0v8wvdfmryqSSVpMpImoau2OpcfPrrmrtDD
	2mk7nR+tjvZ6N/3gJfXDSizFGYmGWsxFxYkA/8HSPHACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "skyworks" as the vendor prefix for the
Skyworks Solutions, Inc.

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

