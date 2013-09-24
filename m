Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3IXJRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:17:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29366 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3IXJRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:17:52 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-53-524158bf8695
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 17/22] backlight: lv5207lp: use devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:17:50 +0900
Message-id: <005701ceb906$f132e570$d398b050$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAdpFw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zA939EY5BBvdOcFnMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBkHevqZ
	C15xVrw7fZ+1gXEeRxcjJ4eEgInEhU3H2CBsMYkL99YD2VwcQgLLGCWmrDvABlO0qO0+K4gt
	JLCIUeLZ12SIol+MEtPWnGIGSbAJqEl8+XKYvYuRg0NEQF+irUUDJMwskCNx/8ksdoheW4l1
	H2aD2ZwCdhKnlp4Bmy8sECBxZPJZRhCbRUBVYtmP52A1vED1C85B7OUVEJT4MfkeC8RMLYnN
	25pYIWx5ic1r3jKDrJUQUJd49FcXJCwiYCRx5uA6dogSEYl9L94xgpwsIXCOXeJ1dz87xC4B
	iW+TD7FA9MpKbDrADPGupMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRYZ6
	xYm5xaV56XrJ+bmbGCEx2buD8fYB60OMyUDrJzJLiSbnA2M6ryTe0NjMyMLUxNTYyNzSjDRh
	JXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M0pMlmJZYu0U+2tkfeW7tCk6BM2ot
	vv4Xnqxqva/e0LT8VVpPpbv0o2avyCaRUBlV9yI2tuObPml2P1RtOiskl7f964/pOXtOrTbd
	+XJpeLLdikalib3NMzZuXn895eSTcO2OzfVBh+zenjrUc6gtwsAi+v6BF0/PBW3ouzf5veaJ
	afy6y2c9U2Ipzkg01GIuKk4EAAEnDsTfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd39EY5BBm/vsVnMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZB3r6mQtecVa8O32ftYFxHkcXIyeHhICJxKK2+6wQtpjEhXvr
	2UBsIYFFjBLPviZ3MXIB2b8YJaatOcUMkmATUJP48uUwexcjB4eIgL5EW4sGSJhZIEfi/pNZ
	7BC9thLrPswGszkF7CROLT0DNlNYIEDiyOSzjCA2i4CqxLIfz8FqeIHqF5yDuIFXQFDix+R7
	LBAztSQ2b2tihbDlJTavecsMslZCQF3i0V9dkLCIgJHEmYPr2CFKRCT2vXjHOIFRaBaSSbOQ
	TJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH/DPpHYyrGiwOMQpwMCrx
	8F5IcAgSYk0sK67MPcQowcGsJMJ7w9YxSIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgcko
	ryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYiy7cTJq4QFRq
	8ZLcEM+U/GPT+Wc1KN3vf6vmu4Jho+QmrSlRz1a2V2v77xf9Y8H5oElr7vcCg8b8/7cvKVrr
	7jkpU2qh8phBtpVbobv1MPuB20u39Nix5eQ5rzMWi72xZCN3acVRyyVfGh0LTTtSG60+FK0N
	uu+w9kup//eqR3KM+0057GWUWIozEg21mIuKEwGYeDsyPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lv5207lp.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/lv5207lp.c b/drivers/video/backlight/lv5207lp.c
index 8091a28..1802b2d 100644
--- a/drivers/video/backlight/lv5207lp.c
+++ b/drivers/video/backlight/lv5207lp.c
@@ -124,9 +124,9 @@ static int lv5207lp_probe(struct i2c_client *client,
 	props.brightness = clamp_t(unsigned int, pdata->def_value, 0,
 				   props.max_brightness);
 
-	backlight = backlight_device_register(dev_name(&client->dev),
-					      &lv->client->dev, lv,
-					      &lv5207lp_backlight_ops, &props);
+	backlight = devm_backlight_device_register(&client->dev,
+				dev_name(&client->dev), &lv->client->dev,
+				lv, &lv5207lp_backlight_ops, &props);
 	if (IS_ERR(backlight)) {
 		dev_err(&client->dev, "failed to register backlight\n");
 		return PTR_ERR(backlight);
@@ -144,7 +144,6 @@ static int lv5207lp_remove(struct i2c_client *client)
 
 	backlight->props.brightness = 0;
 	backlight_update_status(backlight);
-	backlight_device_unregister(backlight);
 
 	return 0;
 }
-- 
1.7.10.4


