Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab3BZWyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:54:12 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50892 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab3BZWyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:54:10 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 00/15] staging: omap-thermal fixes and ports
Date: Tue, 26 Feb 2013 18:53:23 -0400
Message-ID: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,


Several compilation fixes and a couple of debugging prints
added. This time I am also preparing the driver to receive
fixes and patches from omapzoom. So, this series starts to
port patches from omapzoom to staging area. Most of this
changes are related to OMAP5 support.

All these are based on linux-2.6/master.

Patches are also available here:

git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/omap/omap-thermal-fixes
https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/omap/omap-thermal-fixes

Cheers,

Eduardo Valentin (12):
  staging: omap-thermal: standardize register nomenclature to use 'GPU'
  staging: omap-thermal: remove from register map soc and mode on OMAP5
  staging: omap-thermal: introduce new features of OMAP54xx
  staging: omap-thermal: update OMAP54xx clock sources
  staging: omap-thermal: update feature bitfield for OMAP54xx
  staging: omap-thermal: remove dedicated counter register for OMAP5
  staging: omap-thermal: introduze FREEZE_BIT feature
  staging: omap-thermal: update DT entry documentation
  staging: omap-thermal: add DT example for OMAP54xx devices
  staging: omap-thermal: Remove double conv_table reference
  staging: omap-thermal: name data files accordingly
  staging: omap-thermal: update clock prepare count

Radhesh Fadnis (2):
  staging: omap-thermal: introduce clock feature flag
  staging: omap-thermal: update OMAP54xx conv_table

Ruslan Ruslichenko (1):
  staging: omap-thermal: Add print when TSHUT temperature reached

 drivers/staging/omap-thermal/Makefile             |    4 +-
 drivers/staging/omap-thermal/omap-bandgap.c       |   89 ++++--
 drivers/staging/omap-thermal/omap-bandgap.h       |   94 +++++-
 drivers/staging/omap-thermal/omap4-thermal-data.c |  262 +++++++++++++++
 drivers/staging/omap-thermal/omap4-thermal.c      |  259 ---------------
 drivers/staging/omap-thermal/omap5-thermal-data.c |  357 +++++++++++++++++++++
 drivers/staging/omap-thermal/omap5-thermal.c      |  297 -----------------
 drivers/staging/omap-thermal/omap_bandgap.txt     |   36 ++-
 8 files changed, 794 insertions(+), 604 deletions(-)
 create mode 100644 drivers/staging/omap-thermal/omap4-thermal-data.c
 delete mode 100644 drivers/staging/omap-thermal/omap4-thermal.c
 create mode 100644 drivers/staging/omap-thermal/omap5-thermal-data.c
 delete mode 100644 drivers/staging/omap-thermal/omap5-thermal.c

-- 
1.7.7.1.488.ge8e1c

