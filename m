Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaFIMdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:33:20 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51185 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbaFIMdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:33:16 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM / Documentation: Update copyright in
 suspend-and-cpuhotplug.txt
To: rjw@rjwysocki.net
Cc: rdunlap@infradead.org, viresh.kumar@linaro.org, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 09 Jun 2014 18:01:42 +0530
Message-ID: <20140609123103.11086.12353.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060912-8256-0000-0000-00000DA5C357
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the year to 2014 in the copyright.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/power/suspend-and-cpuhotplug.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/power/suspend-and-cpuhotplug.txt b/Documentation/power/suspend-and-cpuhotplug.txt
index e13dafc..2850df3 100644
--- a/Documentation/power/suspend-and-cpuhotplug.txt
+++ b/Documentation/power/suspend-and-cpuhotplug.txt
@@ -1,6 +1,6 @@
 Interaction of Suspend code (S3) with the CPU hotplug infrastructure
 
-     (C) 2011 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
+     (C) 2011 - 2014 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
 
 
 I. How does the regular CPU hotplug code differ from how the Suspend-to-RAM

