Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbaFIVAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:00:04 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:55373 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753837AbaFIVAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:00:01 -0400
Message-ID: <5396204D.7040708@semaphore.gr>
Date: Mon, 09 Jun 2014 23:59:57 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] cpufreq: intel_pstate: Debugfs file addition and cleanups
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Below some work on intel_pstate driver.
Mostly a cleanup (patches 1/7, 5/7, 6/7, 7/7), some code simplification
(patch 4/7) and the addition of stats file in debugfs that presents
driver's statistics (patch 3/7).

Please note that patch 3/7 depends on 2/7 (which also simplifies calculation
if tracing is on).


Thanks!

Stratos Karafotis (7):
  cpufreq: intel_pstate: Remove duplicate CPU ID check
  cpufreq: intel_pstate: Avoid duplicate call of
    intel_pstate_get_scaled_busy
  cpufreq: intel_pstate: Add debugfs file stats
  cpufreq: intel_pstate: Simplify code in
    intel_pstate_adjust_busy_pstate
  cpufreq: intel_pstate: Remove redundant includes
  cpufreq: intel_pstate: Trivial code cleanup
  cpufreq: intel_pstate: Make intel_pstate_kobject local

 drivers/cpufreq/intel_pstate.c | 237 +++++++++++++++++++++++------------------
 1 file changed, 135 insertions(+), 102 deletions(-)

-- 
1.9.3
