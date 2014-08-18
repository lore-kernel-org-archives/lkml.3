Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaHRLAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:00:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29913 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaHRLAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:00:05 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-72-53f1dcb3b0d0
Date: Mon, 18 Aug 2014 20:00:03 +0900
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH v3 1/2] mfd: arizona: Add support for INn_Modec
 register control
Message-id: <20140818200003.2ab8aca0@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkSHfznY/BBr1TRS2uXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWpx7tZLR4v7Xo4wW3650MFlc3jWHzWLp9YtMFsvf/mez
	mDB9LYtF694j7Banu1kd+D02fG5i81gzbw2jx+W+XiaPnbPusnusXP6FzWPTqk42jzvX9rB5
	zDsZ6PFy4m82j74tqxg9Pm+SC+CO4rJJSc3JLEst0rdL4MpYfnUya8E87oqNj5ezNTDO5uxi
	5OSQEDCRmP1xJSOELSZx4d56ti5GLg4hgaWMEvOnLAVKcIAVLV7GChFfxCgxYcNcRginn0ni
	2Po9LCDdLAKqEs/uHGcGsdkENCS+f94MZosATb09p5MZpIFZ4CeTRPOKJ2AJYYF4iWdvz4Ot
	5hVwlTg/uZUJ4gwbidU71zFDxAUlfky+B7aAWUBLYvO2JlYIW15i85q3YEMlBGZySLTdWMIE
	cYWAxLfJh1ggzpaV2HSAGWKmpMTBFTdYJjCKzEIydhaSsbOQjF3AyLyKUTS1ILmgOCm9yEiv
	ODG3uDQvXS85P3cTIzCiT/971reD8eYB60OMyUArJzJLiSbnAxNCXkm8obGZkYWpiamxkbml
	GWnCSuK8ix4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpglH9laqZ0Jsgp/cHLNU9mF5R9
	e+lqwanhbpd78Ztw4TKOtZzhOfX7bi1d+HKPccGOqknP+USm3vCwyz0pYnXu+3uT+QIxWhOy
	PLP+qaRtMLSe/+/BBd9vN3W2VU12fhXI/KPsL0/TNoUe1slV7S+iHivtfLC1ZtVPQRn/aNYu
	w10uvq6HePkvKrEUZyQaajEXFScCAJXOPFv+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAd3Ndz4GG1z4xWNx5eIhJoupD5+w
	WfybcoPd4vqX56wW84+cY7Xof7OQ1eLcq5WMFve/HmW0+Halg8ni8q45bBZLr19kslj+9j+b
	xYTpa1ksWvceYbc43c3qwO+x4XMTm8eaeWsYPS739TJ57Jx1l91j5fIvbB6bVnWyedy5tofN
	Y97JQI+XE3+zefRtWcXo8XmTXAB3VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGl
	hbmSQl5ibqqtkotPgK5bZg7QL0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBA
	whrGjOVXJ7MWzOOu2Ph4OVsD42zOLkYODgkBE4nFy1i7GDmBTDGJC/fWs3UxcnEICSxilJiw
	YS4jhNPPJHFs/R4WkCoWAVWJZ3eOM4PYbAIaEt8/bwazRYC6b8/pZAZpYBb4ySTRvOIJWEJY
	IF7i2dvzjCA2r4CrxPnJrUwQ62wkVu9cxwwRF5T4Mfke2AJmAS2JzduaWCFseYnNa94yT2Dk
	m4WkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4Xz6R2MK5ssDjEKMDB
	qMTD6/H6Q7AQa2JZcWXuIUYJDmYlEd7s8x+DhXhTEiurUovy44tKc1KLDzGaAr09kVlKNDkf
	mMrySuINjU3MjCyNzA0tjIzNlcR5D7RaBwoJpCeWpGanphakFsH0MXFwSjUwxk7q3141ecmj
	co9a15fBurG2J3hMp6QvMbPLuprBl7h+scqiCcv7Y4TnPsmQ+hx4cWpPjNb+OTL6X3SOrXzY
	t9xt8bsPJbMeRqldmhN2v8Uh8F0O25bjG4N0vMR8MibduL34wKyVywSkBW/6WOXY7LoewRCR
	w7S8hbn9TXd0V39wmEPv/HheJZbijERDLeai4kQAb9n35y0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some boards need to set the INn_MODE[1:0] register to change
the input signal patch. This wlf,inmode property is optional.
If present, values must be specified less than or equal to
the number of input singals. If values less than the number
of input signals, elements that has not been specifed are set
to 0 by default.

Example:
   - wlf,inmode = <2 0 2>;	/* IN1, IN3 use DMIC */

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 drivers/mfd/arizona-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 10a0cb9..81e6db8 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
 static int arizona_of_get_core_pdata(struct arizona *arizona)
 {
 	struct arizona_pdata *pdata = &arizona->pdata;
-	int ret, i;
+	int ret, i, proplen;
 
 	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
 
@@ -560,6 +560,12 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 			ret);
 	}
 
+	proplen = of_property_count_u32_elems(arizona->dev->of_node,
+					      "wlf,inmode");
+	if (proplen > 0 && proplen <= ARRAY_SIZE(arizona->pdata.inmode))
+		of_property_read_u32_array(arizona->dev->of_node, "wlf,inmode",
+					   arizona->pdata.inmode, proplen);
+
 	return 0;
 }
 
-- 
2.0.0.390.gcb682f8

