Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3FRJ3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:29:42 -0400
Received: from mail.abilis.ch ([195.70.19.74]:29076 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab3FRJ3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:29:39 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH 4/4] Add Abilis Systems Sarl to device tree vendor prefixes
Date: Tue, 18 Jun 2013 11:29:11 +0200
Message-Id: <1371547751-13873-4-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20130618092516.GC18663@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 6931c43..e2a8fff 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -3,6 +3,7 @@ Device tree binding vendor prefix registry.  Keep list in alphabetical order.
 This isn't an exhaustive list, but you should add new prefixes to it before
 using them to avoid name-space collisions.
 
+abilis	Abilis Systems Sarl
 ad	Avionic Design GmbH
 adi	Analog Devices, Inc.
 aeroflexgaisler	Aeroflex Gaisler AB
-- 
1.7.1

