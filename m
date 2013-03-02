Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3CBN1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:27:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:53392 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3CBN13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:27:29 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-65-5131fe401f15
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com
Subject: [PATCH] usb: dwc3: Set DWC3 context's mode based on selected mode.
Date: Sat, 02 Mar 2013 18:55:24 +0530
Message-id: <1362230724-21017-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <CAFp+6iGGAY=nMg03-bqHz=XuNP+1t9mQR=M53HGoqCXv=t+f0Q@mail.gmail.com>
References: <CAFp+6iGGAY=nMg03-bqHz=XuNP+1t9mQR=M53HGoqCXv=t+f0Q@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWyRsSkVtfhn2GgwbSjxhaXd81hs5i9pJ/F
	Ysb5fUwWi5a1MjuweHzeJBfAGMVlk5Kak1mWWqRvl8CVsf3xLvaC9ZwVi64LNDBeY+9i5OCQ
	EDCR2L8pqouRE8gUk7hwbz1bFyMXh5DAUkaJ18232CASJhJNK86zQiQWMUpcfLUXLCEkMIVJ
	4ly7PojNJqAr0fR2FyOILSIgK3H4ym9mkAZmgW5GibmLW5hBEsIC3hJXT+0Gs1kEVCWmr1vL
	AmLzCnhITPtznRlim4LEm9vPwGxOgWCJpV39UMsCJG4v3Q42VELgNZvEidbXbBCDBCS+TT7E
	AvGOrMSmA1BzJCUOrrjBMoFReAEjwypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwPA8/e/Z
	xB2M9w9YH2JMBho3kVlKNDkfGN55JfGGxibmpsamZkaWlpampAkrifPKX5IJFBJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cAYdLk0XVBir8ZFc941u7ty1KQMpv6uWdlns/SqmaD21r39v87v
	cVte+XFhz3GWogC1SQn+a5mVsv72fQkJ5TjyJ1IpaGXiraNGEz/U1DVInmE2qNLYdctAgcXW
	vcTx6Z31+/L+H2pwPCwmc+x92zxlVV3bxoI165MOxPLu2D65KchU7FUd1wElluKMREMt5qLi
	RABM8v/vZQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAV2Hf4aBBrvOa1lc3jWHzWL2kn4W
	ixnn9zFZLFrWyuzA4vF5k1wAY1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0BIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEN
	Y8b2x7vYC9ZzViy6LtDAeI29i5GTQ0LARKJpxXlWCFtM4sK99WxdjFwcQgKLGCUuvtrLBpIQ
	EpjCJHGuXR/EZhPQlWh6u4sRxBYRkJU4fOU3M0gDs0A3o8TcxS3MIAlhAW+Jq6d2g9ksAqoS
	09etZQGxeQU8JKb9uc4MsU1B4s3tZ2A2p0CwxNKufqhlARK3l25nnsDIu4CRYRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcPg/k97BuKrB4hCjAAejEg9vwEeDQCHWxLLiytxDjBIczEoi
	vOevGgYK8aYkVlalFuXHF5XmpBYfYkwGumois5Rocj4wNvNK4g2NTcxNjU0tTSxMzCxJE1YS
	52U89SRASCA9sSQ1OzW1ILUIZgsTB6dUA6MSf9t0wZO7CmV3CM0oPSG49R7n2bmL/K2/TOv+
	sWzeK6m7qq33T/1RWJotrcYi8SBWL/jtu5rXG34uKC+ZdSdjde7bIulTq/8I/UmYNmvO6l/m
	njENh6/9jG8r+Lb48FOehu3ZuRJdDw/4/NLSPbTy+PuN4V/3b7uma8Fx8vGdE8wvb7qbNW9d
	r8RSnJFoqMVcVJwIAJRFin7DAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that machines may select the mode of working of DWC3 (HOST only,
GADGET only or DUAL_ROLE), lets set DWC3 mode based on that
rather than fixing it to whatever DWC3 hardware says.
This way we can skip initializing Gadget/Host in case
we are using Host-only/Gadget-only mode respectively.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Changes from RFC patch "usb: dwc3: Set GCTL.PrtCapDir based on selected mode"
 - Setting the mode in dwc3 context structure based on
   selected mode in machine, rather than programming PrtCapDir

 drivers/usb/dwc3/core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 79f335f..be0672f 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -478,7 +478,12 @@ static int dwc3_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	mode = DWC3_MODE(dwc->hwparams.hwparams0);
+	if (IS_ENABLED(CONFIG_USB_DWC3_HOST))
+		mode = DWC3_MODE_HOST;
+	else if (IS_ENABLED(CONFIG_USB_DWC3_GADGET))
+		mode = DWC3_MODE_DEVICE;
+	else
+		mode = DWC3_MODE_DRD;
 
 	switch (mode) {
 	case DWC3_MODE_DEVICE:
-- 
1.7.6.5

