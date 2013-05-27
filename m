Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab3E0Nc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:32:27 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36433 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab3E0NcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:32:25 -0400
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH 1/3] ARM: ux500: use #include syntax to include *.dtsi.
Date: Mon, 27 May 2013 15:30:53 +0200
Message-Id: <1369661455-17839-2-git-send-email-gabriel.fernandez.st@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369661455-17839-1-git-send-email-gabriel.fernandez.st@gmail.com>
References: <1369661455-17839-1-git-send-email-gabriel.fernandez.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

This patch prepares the use of '#define' into dts files.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 arch/arm/boot/dts/ccu8540.dts     | 2 +-
 arch/arm/boot/dts/ccu9540.dts     | 2 +-
 arch/arm/boot/dts/dbx5x0.dtsi     | 2 +-
 arch/arm/boot/dts/href.dtsi       | 2 +-
 arch/arm/boot/dts/hrefprev60.dts  | 6 +++---
 arch/arm/boot/dts/hrefv60plus.dts | 6 +++---
 arch/arm/boot/dts/snowball.dts    | 2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/ccu8540.dts b/arch/arm/boot/dts/ccu8540.dts
index 18daa01..5de9e1e 100644
--- a/arch/arm/boot/dts/ccu8540.dts
+++ b/arch/arm/boot/dts/ccu8540.dts
@@ -10,7 +10,7 @@
  */
 
 /dts-v1/;
-/include/ "dbx5x0.dtsi"
+#include "dbx5x0.dtsi"
 
 / {
 	model = "ST-Ericsson U8540 platform with Device Tree";
diff --git a/arch/arm/boot/dts/ccu9540.dts b/arch/arm/boot/dts/ccu9540.dts
index c72d7aa..c76ec3a 100644
--- a/arch/arm/boot/dts/ccu9540.dts
+++ b/arch/arm/boot/dts/ccu9540.dts
@@ -10,7 +10,7 @@
  */
 
 /dts-v1/;
-/include/ "dbx5x0.dtsi"
+#include "dbx5x0.dtsi"
 
 / {
 	model = "ST-Ericsson CCU9540 platform with Device Tree";
diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index cd5cd09..f85ff85 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -9,7 +9,7 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
 
 / {
 	soc {
diff --git a/arch/arm/boot/dts/href.dtsi b/arch/arm/boot/dts/href.dtsi
index e315429..d01a8e1 100644
--- a/arch/arm/boot/dts/href.dtsi
+++ b/arch/arm/boot/dts/href.dtsi
@@ -9,7 +9,7 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
-/include/ "dbx5x0.dtsi"
+#include "dbx5x0.dtsi"
 
 / {
 	memory {
diff --git a/arch/arm/boot/dts/hrefprev60.dts b/arch/arm/boot/dts/hrefprev60.dts
index 8a9357b..23c6dc1 100644
--- a/arch/arm/boot/dts/hrefprev60.dts
+++ b/arch/arm/boot/dts/hrefprev60.dts
@@ -10,9 +10,9 @@
  */
 
 /dts-v1/;
-/include/ "dbx5x0.dtsi"
-/include/ "href.dtsi"
-/include/ "stuib.dtsi"
+#include "dbx5x0.dtsi"
+#include "href.dtsi"
+#include "stuib.dtsi"
 
 / {
 	model = "ST-Ericsson HREF (pre-v60) platform with Device Tree";
diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index 5dfc73a..9703a4f 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -10,9 +10,9 @@
  */
 
 /dts-v1/;
-/include/ "dbx5x0.dtsi"
-/include/ "href.dtsi"
-/include/ "stuib.dtsi"
+#include "dbx5x0.dtsi"
+#include "href.dtsi"
+#include "stuib.dtsi"
 
 / {
 	model = "ST-Ericsson HREF (v60+) platform with Device Tree";
diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index e8219cc7..2504267 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -10,7 +10,7 @@
  */
 
 /dts-v1/;
-/include/ "dbx5x0.dtsi"
+#include "dbx5x0.dtsi"
 
 / {
 	model = "Calao Systems Snowball platform with device tree";
-- 
1.8.1.1

