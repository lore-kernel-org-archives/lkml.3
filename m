Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3FFNwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:52:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:46646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab3FFNwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:52:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,815,1363158000"; 
   d="scan'208";a="325240140"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: chris@chris-wilson.co.uk, daniel@ffwll.ch, jani.nikula@intel.com
Subject: [PATCH 0/3] 
Date: Thu,  6 Jun 2013 16:53:01 +0300
Message-Id: <cover.1370525922.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Andrew -

Patch 1 is for DMI, bugfixes in patches 2-3 for i915 and included for
completeness. After a tested-by they should be good for stable. I'll
leave it to Daniel to sort out how the last two get in.

BR,
Jani.

Chris Wilson (1):
  drm/i915: Quirk away phantom LVDS on Intel's D510MO mainboard

Jani Nikula (2):
  dmi: add support for exact DMI matches in addition to substring
    matching
  drm/i915: Quirk away phantom LVDS on Intel's D525MW mainboard

 drivers/firmware/dmi_scan.c       |   12 +++++++++---
 drivers/gpu/drm/i915/intel_lvds.c |   16 ++++++++++++++++
 include/linux/mod_devicetable.h   |    6 ++++--
 3 files changed, 29 insertions(+), 5 deletions(-)

-- 
1.7.9.5

