Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3DWVtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:49:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39637 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab3DWVtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:49:02 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 0/9] thermal: clean ups on thermal code base
Date: Tue, 23 Apr 2013 17:48:11 -0400
Message-ID: <1366753700-1412-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rui,

This is v2 of this series. I have worked on the comments you sent
on these patches. For your reference, v1 has been reviewed at [1].

Summary of changelog:
- Added your acked-by on those patches you granted.
- Fixed the comments regarding functions that are not going
to be exported.
- Removed patches that are touching functions that are not
going to be exported.

Also available, as usual, here:
git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/thermal_core/coding_style
https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/thermal_core/coding_style

The above branches are based on linux-next/master.

All best,

[1] - https://lkml.org/lkml/2013/4/8/471

Eduardo Valentin (9):
  thermal: use strlcpy instead of strcpy
  thermal: update driver license
  thermal: rename notify_thermal_framework to thermal_notify_framework
  thermal: use EXPORT_SYMBOL_GPL
  thermal: update kernel-doc for thermal_zone_bind_cooling_device
  thermal: update kernel-doc for thermal_zone_unbind_cooling_device
  thermal: update kernel-doc for thermal_cooling_device_register
  thermal: update kernel-doc for create_trip_attrs
  thermal: update kernel-doc for thermal_zone_device_register

 Documentation/thermal/sysfs-api.txt |  2 +-
 drivers/thermal/thermal_core.c      | 80 ++++++++++++++++++++++++++-----------
 include/linux/thermal.h             |  2 +-
 3 files changed, 59 insertions(+), 25 deletions(-)

-- 
1.8.2.1.342.gfa7285d

