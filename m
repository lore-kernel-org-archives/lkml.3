Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaDOLxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:53:43 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57079 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbaDOLuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:50:46 -0400
From: Mohit Kumar <mohit.kumar@st.com>
To: <spear-devel@list.st.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Pratyush Anand <pratyush.anand@st.com>, Mohit Kumar <mohit.kumar@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: [PATCH V8 4/9] SPEAr: misc: Add binding information
Date: Tue, 15 Apr 2014 17:19:46 +0530
Message-ID: <4a1155798bd63b0ac0b731e9808496d038af596d.1397555158.git.mohit.kumar@st.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1397555158.git.mohit.kumar@st.com>
References: <cover.1397555158.git.mohit.kumar@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-14_01:2014-04-14,2014-04-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratyush Anand <pratyush.anand@st.com>

SPEAr SOCs have some miscellaneous registers which are used to configure
few properties of different peripheral controllers.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mohit Kumar <mohit.kumar@st.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: spear-devel@list.st.com
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/arm/spear-misc.txt         |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/spear-misc.txt

diff --git a/Documentation/devicetree/bindings/arm/spear-misc.txt b/Documentation/devicetree/bindings/arm/spear-misc.txt
new file mode 100644
index 0000000..cf64982
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/spear-misc.txt
@@ -0,0 +1,9 @@
+SPEAr Misc configuration
+===========================
+SPEAr SOCs have some miscellaneous registers which are used to configure
+few properties of different peripheral controllers.
+
+misc node required properties:
+
+- compatible Should be	"st,spear1340-misc", "syscon".
+- reg: Address range of misc space upto 8K
-- 
1.7.0.1

