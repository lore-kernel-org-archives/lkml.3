Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaDBOkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:40:42 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:61496 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbaDBOki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:40:38 -0400
Date: Wed, 2 Apr 2014 10:40:20 -0400
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Mark Brown <broonie@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] arm64: Fix duplicated Kconfig entries again
Message-ID: <20140402144020.GA20438@zod>
References: <CA+5PVA6awqaSHQboqdv9nynV9Xjp46VeqijDWxZX1v5wDK0NWQ@mail.gmail.com>
 <CAKohpok3gKyOWD0=pSv0yQLNqJcNPNZagRGFXNFHW+3J7E=mOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpok3gKyOWD0=pSv0yQLNqJcNPNZagRGFXNFHW+3J7E=mOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 74397174989e5f70 attempted to clean up the power management options
for arm64, but when things were merged it didn't fully take effect.  Fix
it again.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 arch/arm64/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 07aa3556952c..8033b9b8a2df 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -321,12 +321,6 @@ menu "CPU Power Management"
 
 source "drivers/cpuidle/Kconfig"
 
-source "drivers/cpufreq/Kconfig"
-
-endmenu
-
-menu "Power management options"
-
 source "kernel/power/Kconfig"
 
 source "drivers/cpufreq/Kconfig"
-- 
1.8.5.3

