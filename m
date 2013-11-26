Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3KZH5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:57:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:47617 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3KZH5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:57:43 -0500
X-AuditID: cbfee691-b7f666d0000048b0-07-52945474261e
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@gmail.com, a.sim@samsung.com
Subject: [PATCH] extcon: fix switch class porting guide (Documentation)
Date: Tue, 26 Nov 2013 16:57:39 +0900
Message-id: <1385452659-19417-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWyRsSkULc0ZEqQQdsCVot3VzoYLa5/ec5q
	cXnXHDaL55s6WR1YPHbOusvu0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBnnFx1kKpjBW7F1
	yn2WBsYJ3F2MnBwSAiYSB9oesEHYYhIX7q0Hsrk4hASWMkrceDeRpYuRA6xob6s6RHwRo8T+
	DW3sEE4bk8TxNYuYQLrZBHQltm64ywJiiwgoSGzufcYKYjMLuEgsvXmCGcQWFnCXWN1xByzO
	IqAqsfHCDrBeXgEPibc7+9khrlCQWPZlLTPIAgmB+2wSV35cYodoEJD4NvkQ1EWyEpsOMEPU
	S0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYgUF4+t+ziTsY7x+wPsSY
	DDRuIrOUaHI+MIjzSuINjc2MLExNTI2NzC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoFRXkmGSeGxi6D3bCYbxtkCE0WqedYc9S9LKLOafi/QeY9oUP3ff1JPT9x7aNVY
	k/g85tKqqU2f63bO9d/5Lazx6ynPX2Yniks0y6basVt9WX08cO6l2nsxsqHqVg8PGU3IDCx5
	9CXTqPodJ9svD9tV30WZzjytt9c0mzrj0NXQHf/3HBRvEUlVYinOSDTUYi4qTgQA9ZDZPVgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAd2SkClBBo86rC3eXelgtLj+5Tmr
	xeVdc9gsnm/qZHVg8dg56y67R9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmnF90kKlgBm/F1in3WRoYJ3B3MXJwSAiYSOxtVe9i5AQyxSQu3FvP1sXI
	xSEksIhRYv+GNnYIp41J4viaRUwgVWwCuhJbN9xlAbFFBBQkNvc+YwWxmQVcJJbePMEMYgsL
	uEus7rgDFmcRUJXYeGEHWC+vgIfE25397BDbFCSWfVnLPIGRewEjwypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4BB/Jr2DcVWDxSFGAQ5GJR5eic7JQUKsiWXFlbmHGCU4mJVEeF3vA4V4
	UxIrq1KL8uOLSnNSiw8xJgNtn8gsJZqcD4y/vJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJ
	pCeWpGanphakFsFsYeLglGpgdJDvfHnYw9rVtVchbYPrPPb5wUumsxx5XrLzOrd7Sq8Ov2uk
	y2XpxksLzshITHrK4fw3dP0ttxeS54VntZtpHl/Canjm4gHD8J4zJ+bGnLVUucwU4B6wXfCb
	wJUt/lfyRQ8fefDaODVXxrTDIql0uo1m5J/Ha3zLNAvT5ollJ5olN5S+zvZVYinOSDTUYi4q
	TgQA1Bwa4bUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Unfinished sentence finished.
- Incorrect description on the compat-mode condition corrected.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 Documentation/extcon/porting-android-switch-class |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/extcon/porting-android-switch-class b/Documentation/extcon/porting-android-switch-class
index eb0fa5f..ec5f92d 100644
--- a/Documentation/extcon/porting-android-switch-class
+++ b/Documentation/extcon/porting-android-switch-class
@@ -48,7 +48,7 @@ so that they are still compatible with legacy userspace processes.
 	Extcon's extended features for switch device drivers with
 	complex features usually required magic numbers in state
 	value of switch_dev. With extcon, such magic numbers that
-	support multiple cables (
+	support multiple cables are no more required or supported.
 
   1. Define cable names at edev->supported_cable.
   2. (Recommended) remove print_state callback.
@@ -112,11 +112,8 @@ exclusive, the two cables cannot be in ATTACHED state simulteneously.
 
 ****** ABI Location
 
-  If "CONFIG_ANDROID" is enabled and "CONFIG_ANDROID_SWITCH" is
-disabled, /sys/class/switch/* are created as symbolic links to
-/sys/class/extcon/*. Because CONFIG_ANDROID_SWITCH creates
-/sys/class/switch directory, we disable symboling linking if
-CONFIG_ANDROID_SWITCH is enabled.
+  If "CONFIG_ANDROID" is enabled, /sys/class/switch/* are created
+as symbolic links to /sys/class/extcon/*.
 
   The two files of switch class, name and state, are provided with
 extcon, too. When the multistate support (STEP 2 of CHAPTER 1.) is
-- 
1.7.5.4

