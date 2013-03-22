Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423082Ab3CVVBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:01:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34459 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423027Ab3CVVBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:01:20 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 00/11] thermal: clean ups on thermal code base
Date: Fri, 22 Mar 2013 17:00:43 -0400
Message-ID: <1363986054-24637-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rui,


Here is a sequence of fixes and documentation improvements
thermal code base. This should be first of a series of changes
I am planing to send out.

On this very first there is no change in functionality, as
the patches only change symbol names and updates kernel-doc
comments and their formants.



For those interested in testing and trying the driver, these patches are
also available, as usual, here:
git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/thermal_fw/coding_style
https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/thermal_fw/coding_style

Eduardo Valentin (11):
  thermal: use strlcpy instead of strcpy
  thermal: update driver license
  thermal: rename notify_thermal_framework to thermal_notify_framework
  thermal: rename get_thermal_instance to thermal_instance_get
  thermal: rename get_tz_trend to thermal_zone_trend_get
  thermal: use EXPORT_SYMBOL_GPL
  thermal: update kernel-doc for thermal_zone_bind_cooling_device
  thermal: update kernel-doc for thermal_zone_unbind_cooling_device
  thermal: update kernel-doc for thermal_cooling_device_register
  thermal: update kernel-doc for create_trip_attrs
  thermal: update kernel-doc for thermal_zone_device_register

 Documentation/thermal/sysfs-api.txt |    6 +-
 drivers/thermal/fair_share.c        |    2 +-
 drivers/thermal/step_wise.c         |    2 +-
 drivers/thermal/thermal_sys.c       |   90 ++++++++++++++++++++++++-----------
 include/linux/thermal.h             |    6 +-
 5 files changed, 70 insertions(+), 36 deletions(-)

-- 
1.7.7.1.488.ge8e1c

