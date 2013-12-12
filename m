Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3LLAnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:43:10 -0500
Received: from alt-proxy11.mail.unifiedlayer.com ([74.220.211.241]:58027 "HELO
	alt-proxy11.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750894Ab3LLAnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:43:07 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 19:43:07 EST
Date: Wed, 11 Dec 2013 16:38:12 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Resume regression in 5a87182aa21d6d5d306840feab9321818dd3e2a3
Message-ID: <20131211163812.297d4c81@jbarnes-desktop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On one of my BYT systems, I see a hang at resume.  Based on my bisect,
it looks like this commit is the culprit:

commit 5a87182aa21d6d5d306840feab9321818dd3e2a3
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Wed Nov 27 09:09:42 2013 +0530

    cpufreq: suspend governors on system suspend/hibernate

Is this a known issue?  If so, is there a fix somewhere already?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
