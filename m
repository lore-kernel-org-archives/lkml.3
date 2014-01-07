Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaAGOyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:54:33 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53700 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaAGOyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:54:25 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [INCOMPLETE PATCH v2 0/4] Get EDID late for VGA switcheroo
Date: Tue,  7 Jan 2014 20:24:28 +0530
Message-Id: <1389106472-11389-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.229.g4448466
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris et al,

I got this far with creating a generic interface for various
get_edid() functions, but I'm stuck now. Where do I get the specific
i2c_adapter from?

I hope the series is okay otherwise.

Thanks.

Ramkumar Ramachandra (4):
  drm/i915: add support for vga_switcheroo reprobe
  drm/i915: factor out intel_lvds_get_edid()
  drm/i915: change intel_sdvo_get_edid() prototype
  drm/i915: introduce intel_connector->reprobe

 drivers/gpu/drm/i915/i915_dma.c   |   8 ++-
 drivers/gpu/drm/i915/intel_crt.c  |   1 +
 drivers/gpu/drm/i915/intel_dp.c   |   1 +
 drivers/gpu/drm/i915/intel_drv.h  |   6 +++
 drivers/gpu/drm/i915/intel_lvds.c | 101 ++++++++++++++++++++++----------------
 drivers/gpu/drm/i915/intel_sdvo.c |  17 ++++---
 6 files changed, 84 insertions(+), 50 deletions(-)

-- 
1.8.5.2.229.g4448466

