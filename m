Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965216AbaKLCvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:51:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965167AbaKLBnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:43:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.14 112/203] cpufreq: intel_pstate: Add CPU ID for Braswell processor
Date: Wed, 12 Nov 2014 10:16:22 +0900
Message-Id: <20141112011547.822772049@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 16405f98bca8eb39a23b3ce03e241ca19e7af370 upstream.

This is pretty much the same as Intel Baytrail, only the CPU ID is
different. Add the new ID to the supported CPU list.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -690,6 +690,7 @@ static const struct x86_cpu_id intel_pst
 	ICPU(0x3f, core_params),
 	ICPU(0x45, core_params),
 	ICPU(0x46, core_params),
+	ICPU(0x4c, byt_params),
 	ICPU(0x4f, core_params),
 	ICPU(0x56, core_params),
 	{}


