Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaLHJVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:21:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:62594 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaLHJVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:21:19 -0500
X-AuditID: cbfee68d-f79296d000004278-b7-54856d898c00
From: Inha Song <ideal.song@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, ckeepax@opensource.wolonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel][PATCH 1/2] mfd: arizona: Add support for OUTn_MONO
 register control
Date: Mon, 08 Dec 2014 18:20:21 +0900
Message-id: <1418030422-27061-2-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1418030422-27061-1-git-send-email-ideal.song@samsung.com>
References: <1418030422-27061-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWyRsSkRLcztzXE4OVPRYupD5+wWfzZd5zR
	Yv6Rc6wW/W8Wslrs+nuf0eLcq5WMFve/HmW0uLxrDpvF0usXmSyWv/3PZjFh+loWi9a9R9gt
	TnezOvB6rJm3htHjcl8vk8fK5V/YPDat6mTzuHNtD5vHvJOBHi8n/gYK7fnN7NG3ZRWjx+dN
	cgFcUVw2Kak5mWWpRfp2CVwZLVP/shb84qh4276TpYFxKXsXIyeHhICJxIJDGxghbDGJC/fW
	s3UxcnEICSxllFi1ZTMbTFHLwkksEIlFjBIv7/xkgnDmMEks7b7HClLFJqAh8f3zZuYuRg4O
	EQEdies30kFqmAV2MUlsfn+HGaRGWCBa4uSDXUwgNouAqsTf2W/BVvMKuEkcfPeEBWKbtsS+
	hplgmzkF3CWOLHkKFhcCqjl3rQnsCgmBt+wSXxbeZoMYJCDxbfIhFpDFEgKyEpsOMEPMkZQ4
	uOIGywRG4QWMDKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxAmPq9L9nvTsYbx+wPsQowMGo
	xMO74EFLiBBrYllxZe4hRlOgDROZpUST84GRm1cSb2hsZmRhamJqbGRuaaYkzqso9TNYSCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+NNW/W1h7ql/m+7dnPWsRqTSWU9h8tFFrLqJHy9ef7b
	00v/Ztuf375jQfQDZakSiYkvstV4nB9P+fi53PdVY/ftzHeP9B4Y+rimXRFgsnm3VKF0ccQa
	TY6PMzvM7O41N0fULr+qcUB8T7m/y9aKexeCptz1W73+W7DX/Oy3kXufnGHeuZ6b0XCVEktx
	RqKhFnNRcSIAPK58Y6QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd3O3NYQg3tdUhZTHz5hs/iz7zij
	xfwj51gt+t8sZLXY9fc+o8W5VysZLe5/PcpocXnXHDaLpdcvMlksf/ufzWLC9LUsFq17j7Bb
	nO5mdeD1WDNvDaPH5b5eJo+Vy7+weWxa1cnmcefaHjaPeScDPV5O/A0U2vOb2aNvyypGj8+b
	5AK4ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	jldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZrRM/cta8Iuj4m37TpYG
	xqXsXYycHBICJhItCyexQNhiEhfurWfrYuTiEBJYxCjx8s5PJghnDpPE0u57rCBVbAIaEt8/
	b2buYuTgEBHQkbh+Ix2khllgF5PE5vd3mEFqhAWiJU4+2MUEYrMIqEr8nf2WEcTmFXCTOPju
	CdQ2bYl9DTPZQGxOAXeJI0uegsWFgGrOXWtimcDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66
	XnJ+7iZGcMQ+k97BuKrB4hCjAAejEg/vwgctIUKsiWXFlbmHGCU4mJVEeBPjWkOEeFMSK6tS
	i/Lji0pzUosPMZoCXTWRWUo0OR+YTPJK4g2NTcyMLI3MDS2MjM2VxHlv3MwNERJITyxJzU5N
	LUgtgulj4uCUamAsbD6m3uvq5t8SZf7keM055VfxJgLi30Ibg3yf1ryUrkwymjv91L2Y/Vaa
	zjtdfOc8NfN2mjLx2cVtC3q5jnVHb7n4TUW+dqbK2cmZib4GF2w/efxNatrRf7DwoWCyibrU
	oXT+m3fmu3iuzNi6uFc0drL4Ytun+qelKl+dr3geubRIkt1ZZIMSS3FGoqEWc1FxIgCzQ5R1
	7gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some boards need to set the OUTn_MONO register to configurates
the output signal path as a mono differential output. This
wlf,out-mono property is optional. If present, values must be
specified less than or equal to the number of output signals.
If values less than the number of output signals, elements
that has not been specified are set to 0 by default.

Example:
 - wlf,out-mono = <1 0 1>; /* set OUT1,OUT3 to mono differential */

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 drivers/mfd/arizona-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index bce7c07..117be32 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -561,6 +561,16 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 		count++;
 	}
 
+	count = 0;
+	of_property_for_each_u32(arizona->dev->of_node, "wlf,out-mono", prop,
+				 cur, val) {
+		if (count == ARRAY_SIZE(arizona->pdata.out_mono))
+			break;
+
+		arizona->pdata.out_mono[count] = !!val;
+		count++;
+	}
+
 	return 0;
 }
 
-- 
2.0.0.390.gcb682f8

