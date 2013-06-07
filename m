Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3FGI0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:26:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:13716 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab3FGI0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:26:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,820,1363158000"; 
   d="scan'208";a="349578249"
From: shuox.liu@intel.com
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com,
        gregkh@linuxfoundation.org, yanmin_zhang@linux.intel.com
Subject: [PATCH 0/2] Run callback of device_prepare/complete consistently
Date: Fri,  7 Jun 2013 16:20:30 +0800
Message-Id: <1370593232-3602-1-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dpm_run_callback is used in other stages of power states changing.
It provides debug info message and time measurement when call these
callback. We also want to benefit ->prepare and ->complete.

[PATCH 1/2] PM: use dpm_run_callback in device_prepare
[PATCH 2/2] PM: add dpm_run_callback_void and use it in device_complete
