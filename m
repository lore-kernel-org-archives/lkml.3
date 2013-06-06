Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3FFHJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:09:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55738 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3FFHJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:09:37 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-2d-51b035b08ce6
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5/5] cpufreq:boost:Kconfig: Enable boost support at Kconfig
Date: Thu, 06 Jun 2013 09:07:52 +0200
Message-id: <1370502472-7249-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jQd0NphsCDTauErT483Y5q8XTph/s
	FvM+y1p0nn3CbPHmEbfFm4ebGS0u75rDZvG59wijxe3GFWwW/Qt7mSw6jnxjttj41cOBx+PO
	tT1sHuumvWX26NuyitHj0eIWRo/Pm+QCWKO4bFJSczLLUov07RK4Mr7fUimYwVbxo3k6SwNj
	N2sXIyeHhICJRPvq12wQtpjEhXvrwWwhgemMEs+veHYxcgHZXUwSy75tZgdJsAnoSXy++5QJ
	xBYR8JXoWXYIzGYWOMkscfdYIIgtLOAt0b/7LAuIzSKgKnH65gOwXl4BV4mDfVcYIZbJSzy9
	3we2jFPATWLupxdQi10lbn5YyTKBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODw
	eya9g3FVg8UhRgEORiUeXomA9YFCrIllxZW5hxglOJiVRHhjRTYECvGmJFZWpRblxxeV5qQW
	H2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamC09GFQbzpxftOKk9NvMSwqmWAvGqPX
	t1fTOstBZOXOzO/LN14+n3Wh68oL7Qn7Amu72+rfrLje1PZ6J/uDMyekE39JRrKvMO/Y/9LV
	gOmro33M13fnnrutifBQiFW2yIpIeFTCM5VN4I171t1FUnOaJV5quQSpJd9N/bf8zCqLfUrr
	/3F0Le5UYinOSDTUYi4qTgQAHJWc2jsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable/disable support for BOOST. New flag - CPU_FREQ_BOOST has been
defined for that.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index a1488f5..1007c5e 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -23,6 +23,13 @@ config CPU_FREQ_TABLE
 config CPU_FREQ_GOV_COMMON
 	bool
 
+config CPU_FREQ_BOOST
+	bool "CPU frequency boost support"
+	help
+	  Switch to enable support for frequency boost
+
+	  If in doubt, say N.
+
 config CPU_FREQ_STAT
 	tristate "CPU frequency translation statistics"
 	select CPU_FREQ_TABLE
-- 
1.7.10.4

