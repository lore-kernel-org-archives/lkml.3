Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379Ab3DBLdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:33:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46562 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760235Ab3DBLdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 09/16] extcon: arizona: Tune up HPDET debounce
Date: Tue,  2 Apr 2013 12:32:41 +0100
Message-Id: <1364902368-1123-9-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 4022fe2..5344f43 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -39,7 +39,7 @@
 #define ARIZONA_ACCDET_MODE_HPL 1
 #define ARIZONA_ACCDET_MODE_HPR 2
 
-#define HPDET_DEBOUNCE 250
+#define HPDET_DEBOUNCE 500
 
 struct arizona_extcon_info {
 	struct device *dev;
-- 
1.7.10.4

