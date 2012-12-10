Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3HVW5O (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 22 Aug 2013 18:57:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56753 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3HVW5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:57:04 -0400
Message-Id: <0fed3abba1286c59e51087efa02514d79e79ac14.1377202730.git.joshc@codeaurora.org>
In-Reply-To: <cover.1377202730.git.joshc@codeaurora.org>
References: <cover.1377202730.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Mon, 10 Dec 2012 20:41:31 +0100
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH RFC v2 1/5] of: Add empty for_each_available_child_of_node() macro
 definition
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Add this empty macro definition so users can be compiled without
excluding this macro call with preprocessor directives when CONFIG_OF
is disabled.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
This patch was first introduced in December @
http://thread.gmane.org/gmane.linux.drivers.devicetree/26315

 include/linux/of.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 1fd08ca..fefffb3 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -369,6 +369,9 @@ static inline bool of_have_populated_dt(void)
 #define for_each_child_of_node(parent, child) \
 	while (0)
 
+#define for_each_available_child_of_node(parent, child) \
+	while (0)
+
 static inline struct device_node *of_get_child_by_name(
 					const struct device_node *node,
 					const char *name)
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


