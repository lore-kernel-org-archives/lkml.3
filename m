Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965608Ab3E2KlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:41:13 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45682 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965542Ab3E2KlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:41:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: MAINTAINERS: Add git tree path for ARM specific updates
Date: Wed, 29 May 2013 16:10:43 +0530
Message-Id: <aab5b5dc92b960e81e8fd1975eba81234a4ecac8.1369817795.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To reduce cpufreq maintenance load on Rafael, ARM specific patches would be
Applied by me now. Rafael will pull in these changes from time to time (at
rc's). Additionally I would be sending him pull request for every merge window
and rc's (for fixes).

Web interface of my tree is present here:

https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=summary

Branch names would be: cpufreq-next and cpufreq-fixes.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd3a495..50c81bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2216,6 +2216,7 @@ L:	cpufreq@vger.kernel.org
 L:	linux-pm@vger.kernel.org
 S:	Maintained
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
+T:	git://git.linaro.org/people/vireshk/linux.git (For ARM Updates)
 F:	drivers/cpufreq/
 F:	include/linux/cpufreq.h
 
-- 
1.7.12.rc2.18.g61b472e

