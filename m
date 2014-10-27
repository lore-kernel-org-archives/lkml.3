Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaJ0IIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:08:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:33019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbaJ0IIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:08:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,794,1406617200"; 
   d="scan'208";a="621212288"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] MAINTAINERS: Add entry for Intel pin controller drivers
Date: Mon, 27 Oct 2014 10:08:31 +0200
Message-Id: <1414397312-94609-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414397312-94609-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1414397312-94609-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAINTAINERS entry for Intel pin controller drivers. I will be
maintaining them with Heikki, who kindly promised to help me with this.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a20df9bf8ab0..0186441f111d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7163,6 +7163,12 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/pinctrl/pinctrl-at91.c
 
+PIN CONTROLLER - INTEL
+M:	Mika Westerberg <mika.westerberg@linux.intel.com>
+M:	Heikki Krogerus <heikki.krogerus@linux.intel.com>
+S:	Maintained
+F:	drivers/pinctrl/intel/
+
 PIN CONTROLLER - RENESAS
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-sh@vger.kernel.org
-- 
2.1.1

