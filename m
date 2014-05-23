Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaEWSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:16:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35950 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaEWSQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:51 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 02/16] sched: Introduce CONFIG_SCHED_ENERGY
Date: Fri, 23 May 2014 19:16:29 +0100
Message-Id: <1400869003-27769-3-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:47.0776 (UTC) FILETIME=[2918FA00:01CF76B3]
X-MC-Unique: 114052319164904201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIHnJT005161

The Energy-aware scheduler implementation is guarded by
CONFIG_SCHED_ENERGY.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/arm/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ab438cb..bfc3a85 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1926,6 +1926,11 @@ config XEN
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
+config SCHED_ENERGY
+	bool "Energy-aware scheduling (EXPERIMENTAL)"
+	help
+	  Highly experimental energy aware task scheduling.
+
 endmenu
 
 menu "Boot options"
-- 
1.7.9.5


