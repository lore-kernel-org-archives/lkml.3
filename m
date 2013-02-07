Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab3BGK2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:28:03 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52461 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab3BGK17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:27:59 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, valdis.kletnieks@vt.edu, artem.savkov@gmail.com
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/4] CPUFreq Fixes for 3.9
Date: Thu,  7 Feb 2013 15:57:42 +0530
Message-Id: <cover.1360232293.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 07 Feb 2013 10:27:56.0552 (UTC) FILETIME=[CB6E5880:01CE051D]
X-MC-Unique: 113020710275704401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r17AS6eg028046

Hi Rafael,

This is another unplanned patchset for all the platforms that i broke. :)

Okay, there are two important fixes (1 & 4) and two general cleanups (2 & 3). I
hope most of the issues would be resolved by these and we would be able to push
clean cpufreq core into 3.9.

I have pushed them in my for-rafael branch at:

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-rafael

@Artem & Valdis: Please test them and reply with your Tested-by's (in case they
work :) ).

Viresh Kumar (4):
  cpufreq: governors: Fix WARN_ON() for multi-policy platforms
  cpufreq: Remove unused HOTPLUG_CPU code
  cpufreq: Create a macro for unlock_policy_rwsem{read,write}
  cpufreq: Fix locking issues

 drivers/cpufreq/cpufreq.c          | 126 ++++++++++++++++++-------------------
 drivers/cpufreq/cpufreq_governor.c |  32 ++++++----
 2 files changed, 79 insertions(+), 79 deletions(-)

-- 
1.7.12.rc2.18.g61b472e


