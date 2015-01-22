Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbbAVLSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:18:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10062 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbbAVLSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:18:23 -0500
X-AuditID: cbfee691-f79b86d000004a5a-4c-54c0dc7c2aac
From: Inha Song <ideal.song@samsung.com>
To: alsa-devel@alsa-project.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        s.nawrocki@samsung.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, kgene@kernel.org,
        sbkim73@samsung.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        ideal.song@samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [alsa-devel] [PATCH v3 2/4] ASoC: samsung: Document Trats2 audio
 subsystem bindings
Date: Thu, 22 Jan 2015 20:18:00 +0900
Message-id: <1421925482-15861-3-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
References: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkQLf2zoEQgwfxFlcuHmKymPrwCZvF
	/CPnWC363yxktTjwZwejxa6/9xktzr1ayWjR//g1s8W3Kx1MFpseX2O1uLxrDpvFjPP7mCxu
	X+a1WHr9IpPFhOlrWSw6d/WzWrTuPcJucfhNO6vFxRVfmCxebn7D5CDiseFzE5vHmnlrGD1a
	mnvYPC739TJ57Jx1l91j5fIvbB6bVnWyedy5tofNY/OSeo99b5exefRtWcXosfl0tcfnTXIB
	vFFcNimpOZllqUX6dglcGZdXHGQs2MpdsWx9YQPjGc4uRk4OCQETif4TlxghbDGJC/fWs3Ux
	cnEICSxllNhyYxkzTFHj8fesEIlFjBInH1+EqprDJLFp5lOwKjYBDYnvnzcD2RwcIgLyEofe
	54HUMAtcYZb4uGIWWI2wQJzEswcX2EFqWARUJfqOiYKEeQXcJJo3XGWFWKYtsa9hJhuIzSng
	LnHz7lYwWwioZm3fJEaQmRICKzkk1uz4xASSYBEQkPg2+RALyEwJAVmJTQegjpaUOLjiBssE
	RuEFjAyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQLj9fS/ZxN3MN4/YH2IUYCDUYmHN6P4
	QIgQa2JZcWXuIUZToA0TmaVEk/OBSSGvJN7Q2MzIwtTE1NjI3NJMSZxXR/pnsJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQbGOQG/byd5LDS3mfpofcCCqGdlreclCvKsRRh+hWYV7LDhvX7V
	Q8Tif5BxTlvmTS0dM12L8B+ivTqf3PJ+L3q93ezu/X0669nW3kwseDJr6olryfauz3c+/Ppr
	Yqzfx1lR4WtvP9oS6XrfRcl2ucKkJ8Kl6rMOftbZ0/vmjTLvec0Hu5uj23vOK7EUZyQaajEX
	FScCAH7/whvSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG7NnQMhBidfmVhcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9
	q6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMuLziIGPBVu6KZesLGxjP
	cHYxcnJICJhINB5/zwphi0lcuLeerYuRi0NIYBGjxMnHF6GcOUwSm2Y+ZQapYhPQkPj+eTOQ
	zcEhIiAvceh9HkgNs8AVZomPK2aB1QgLxEk8e3CBHaSGRUBVou+YKEiYV8BNonnDVahl2hL7
	GmaygdicAu4SN+9uBbOFgGrW9k1inMDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZG
	cDp4Jr2DcVWDxSFGAQ5GJR7ejOIDIUKsiWXFlbmHGCU4mJVEeE1PAIV4UxIrq1KL8uOLSnNS
	iw8xmgIdNZFZSjQ5H5iq8kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4
	OKUaGFlyJoulKLREqnGEvPvMIVzerxtqerswhvF5x/3r6uyOX6NDIo/fuvEn4azh9GLhuqOe
	uksudTO8P7g1rbtW957LjuO2O6/JeXjM52H/nBIQZpB86OtV1d85i+tlL3QWPQ/zXVUesi1i
	04m7kTP5H1jHLqqO9Fso6bhyb1hf3MN0V3vexkQWJZbijERDLeai4kQA3rTz0h0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Trats2 audio subsystem bindings document.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 .../bindings/sound/samsung,trats2-wm1811.txt       | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt

diff --git a/Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt b/Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt
new file mode 100644
index 0000000..319ff07
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt
@@ -0,0 +1,25 @@
+Samsung Exynos Trats2 audio with WM1811 codec
+
+Required properties:
+
+ - compatible : Must be "samsung,trats2-audio"
+ - samsung,i2s-controller : The phandle of the I2S controller
+ - samsung,model : The user visible name of this sound
+ - samsung,audio-codec : The phandle of the WM1811 audio codec
+ - samsung,audio-routing : A list of the connections between audio
+   components. each entry is a pair of strings, the first being the
+   connection's sink, the second being the connection's source
+
+Example:
+
+sound {
+	compatible = "samsung,trats2-audio";
+	samsung,i2s-controller = <&i2s0>;
+	samsung,model = "Trats2";
+	samsung,audio-codec = <&wm1811>;
+	samsung,audio-routing =
+			"SPK", "SPKOUTLN",
+			"SPK", "SPKOUTLP",
+			"SPK", "SPKOUTRN",
+			"SPK", "SPKOUTRP";
+};
-- 
2.0.0.390.gcb682f8

