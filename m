Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaBFIQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:16:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56228 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaBFIQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:16:20 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-00-52f344d2e2e8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Jin Park'" <jinyoungp@nvidia.com>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 01/12] backlight: aat2870: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:16:18 +0900
Message-id: <000201cf2313$b65183e0$22f48ba0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAAvEQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zA91LLp+DDI51W1vMWb+GzeLywkus
	Fls+nQSyds1hc2DxODHjN4tHb/M7No++LasYPT5vkgtgieKySUnNySxLLdK3S+DKmHf5PVNB
	I1vFxF9pDYy/WLoYOTkkBEwkdp1oYYawxSQu3FvP1sXIxSEksIxRYsfNG4wwRTOOvGSHSExn
	lPh9bT4LhPOLUaJ95gdWkCo2ATWJL18OA1VxcIgI6Eu0tWiAhJkFMiUmL7vEBmILCdhK7D59
	EqycU8BOYtunViYQW1jAS+JDy012EJtFQFXi29O/YNfxAtV33mphhLAFJX5MvscCMVNLYv3O
	40wQtrzE5jVvmUHWSgioSzz6qwsSFhEwkti4/QgrRImIxL4X7xhBTpYQOMcucXX7LRaIXQIS
	3yYfYoHolZXYdAAaEJISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpReZ6hUn
	5haX5qXrJefnbmKExOTEHYz3D1gfYkwGWj+RWUo0OR8Y03kl8YbGZkYWpiamxkbmlmakCSuJ
	86Y/SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLjAOEL5iQTX77VTtvCwbKsJ06/bsL5R
	3f1fXfw0vh9+ZamZL7humRpsC3zfsIcpVM588/VWvxRzrqvmUQs/aGUUa5/inZiievdpmW7a
	Bh29/3waBVW7y97qlE5tvbBh7fwX6SvYXuYlznc9W7+HfU7hiz9O0gKSoXz76n63V7KnrPl+
	8OArfSWW4oxEQy3mouJEAAR3X1rfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd1LLp+DDC5dN7eYs34Nm8XlhZdY
	LbZ8Oglk7ZrD5sDicWLGbxaP3uZ3bB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFNJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmDHv8numgka2iom/0hoYf7F0MXJySAiYSMw48pIdwhaTuHBvPVsX
	IxeHkMB0Ronf1+azQDi/GCXaZ35gBaliE1CT+PLlMFAHB4eIgL5EW4sGSJhZIFNi8rJLbCC2
	kICtxO7TJ8HKOQXsJLZ9amUCsYUFvCQ+tNwEW8YioCrx7elfsCN4geo7b7UwQtiCEj8m32OB
	mKklsX7ncSYIW15i85q3zCBrJQTUJR791QUJiwgYSWzcfoQVokREYt+Ld4wTGIVmIZk0C8mk
	WUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcMQ/k97BuKrB4hCjAAejEg/v
	hvWfgoRYE8uKK3MPMUpwMCuJ8G41/xwkxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAZJRX
	Em9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzzJtrOnlv11m6e
	ycFZb6v3ZW57N2uxau+lyzsC38ocjNh2acbiclbTqTFT1Zcrm4d0hmsd2swx6W9uXuZ31dZo
	/z8RHEv3HvwVf7v5vphcxtKgx4wfolI2Pcg3fT7/nmub9OFCjZQIj6VLDLkNogsrt7UvfbWy
	KOXs9/sTOw9JfjDue7xHX4JLiaU4I9FQi7moOBEARNRVYDwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/aat2870_bl.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
index ee0c0a9..ec5350f 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -149,8 +149,6 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 				  sizeof(struct aat2870_bl_driver_data),
 				  GFP_KERNEL);
 	if (!aat2870_bl) {
-		dev_err(&pdev->dev,
-			"Failed to allocate memory for aat2870 backlight\n");
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
1.7.10.4


