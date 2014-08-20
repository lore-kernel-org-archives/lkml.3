Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaHTNqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:46:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25697 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaHTNpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:45:10 -0400
X-AuditID: cbfee61b-f79f86d00000144c-d5-53f4a664901c
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v5 08/10] of: Add Skyworks Solutions, Inc. vendor prefix
Date: Wed, 20 Aug 2014 15:44:17 +0200
Message-id: <1408542259-415-9-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jAd2UZV+CDS5c1bPYOGM9q8X8I+dY
	LfrfLGS1OPdqJaNF79XnjBZnm96wW1zeNYfNYuubdYwWPRu2slosvX6RyWLC9LUsFq17j7A7
	8HismbeG0eNyXy+Tx8rlX9g8Nq3qZPPo27KK0ePzJrkAtigum5TUnMyy1CJ9uwSujLef/jMW
	rOGoWHF4LXsD4wz2LkZODgkBE4ktL35A2WISF+6tZ+ti5OIQEljEKPF86QpWCKedSaLzfjsz
	SBWbgKHEzxevmUBsEYFyiZ73z8A6mAUWM0lM7XnBBpIQFvCRmHr5JQuIzSKgKtE89wvYCl4B
	N4kDXycADeIAWqcgMWeSDYjJKeAuseW9CkiFEFDF6XezWSYw8i5gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERyQz6R3MK5qsDjEKMDBqMTDe2PRl2Ah1sSy4srcQ4wSHMxKIrztnUAh
	3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjNIu994umrja
	J9TqYIbhyj0yMg6eEnOVTWJEJt3ivsucWLtX+sfn6DBVjx+vHi29+atw858X1zItDcU15wc3
	XzwWZvf98uTbWoI9q1ycS7fOao7p5i1rSXxV0vjt+OkP5V3FeS/WHdwW9HOn9furJ73Uozkd
	+EIfHK5Xuqy2tnS14bnX0Y8usiuxFGckGmoxFxUnAgAMMJvYRAIAAA==
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
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 34cc1bf..e1c6317 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -118,6 +118,7 @@ renesas	Renesas Electronics Corporation
 ricoh	Ricoh Co. Ltd.
 rockchip	Fuzhou Rockchip Electronics Co., Ltd
 samsung	Samsung Semiconductor
+skyworks	Skyworks Solutions, Inc.
 sbs	Smart Battery System
 schindler	Schindler
 seagate	Seagate Technology PLC
-- 
1.7.9.5

