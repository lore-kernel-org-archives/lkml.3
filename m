Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab3IQBIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 21:08:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36744 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3IQBIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 21:08:11 -0400
Message-ID: <5237AB72.5020806@infradead.org>
Date: Mon, 16 Sep 2013 18:08:02 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH] regulator: fix fatal kernel-doc error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix fatal kernel-doc error in <linux/regulator/driver.h>:

Error(include/linux/regulator/driver.h:52): cannot understand prototype: 'struct regulator_linear_range '

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Liam Girdwood <lgirdwood@gmail.com>
Cc:	Mark Brown <broonie@kernel.org>
---
 include/linux/regulator/driver.h |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-312-rc1.orig/include/linux/regulator/driver.h
+++ lnx-312-rc1/include/linux/regulator/driver.h
@@ -40,6 +40,8 @@ enum regulator_status {
 };
 
 /**
+ * struct regulator_linear_range - specify voltage ranges
+ *
  * Specify a range of voltages for regulator_map_linar_range() and
  * regulator_list_linear_range().
  *
