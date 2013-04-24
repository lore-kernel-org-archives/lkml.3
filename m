Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3DXSQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:16:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39253 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab3DXSQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:16:37 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 0/2] staging: ti-soc-thermal: couple of fixes
Date: Wed, 24 Apr 2013 14:16:06 -0400
Message-ID: <1366827368-14316-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

Here are two patches on ti-soc-thermal driver.

One is to update the documentation of the OMAP5430 DT entry reference.
The other one adds the support to extrapolation rules with PCB sensor
querying. The second one depends on the API change, that is going
via the thermal tree [1].

These two patches are also available here:
git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/ti-soc-thermal/fixes
https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/ti-soc-thermal/fixes

All best,

[1] - http://git.kernel.org/cgit/linux/kernel/git/rzhang/linux.git/commit/?h=next&id=63c4d919cf66b1b3ffa7861bddb50a697914af5b
[2] - http://git.kernel.org/cgit/linux/kernel/git/rzhang/linux.git/commit/?h=next&id=837b26bb2e4a83d224e725f07a1d9ca824bf905c

Eduardo Valentin (2):
  staging: ti-soc-thermal: update DT reference for OMAP5430
  staging: ti-soc-thermal: remove external heat while extrapolating
    hotspot

 drivers/staging/ti-soc-thermal/ti-thermal-common.c | 30 ++++++++++++++--------
 drivers/staging/ti-soc-thermal/ti_soc_thermal.txt  |  1 +
 2 files changed, 21 insertions(+), 10 deletions(-)

-- 
1.8.2.1.342.gfa7285d

