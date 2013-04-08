Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3DHQIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:08:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35802 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab3DHQIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:08:02 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: From: Eduardo Valentin <eduardo.valentin@ti.com>
Date: Mon, 8 Apr 2013 12:07:27 -0400
Message-ID: <1365437258-31412-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Here is a sequence of fixes and documentation improvements
thermal code base. This should be first of a series of changes
I am planing to send out.

On this very first there is no change in functionality, as
the patches only change symbol names and updates kernel-doc
comments and their formants.



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

