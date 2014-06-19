Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126AbaFSSt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:49:28 -0400
Received: from sauhun.de ([89.238.76.85]:37032 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbaFSSt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:49:27 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, dri-devel@lists.freedesktop.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 0/3] Remove devm_request_and_ioremap()
Date: Thu, 19 Jun 2014 20:48:58 +0200
Message-Id: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pretty much a year ago, Tushar cleaned up a lot of deprecated uses of
devm_request_and_ioremap, yet some remains are still left. Remove the last two
users, and let the function rest in peace. I'd suggest that this series is
picked up as a whole to have that case finally closed. Greg? Are you interested
in picking it up?

   Wolfram


Tushar Behera (2):
  DRM: Armada: Use devm_ioremap_resource
  lib: devres: Remove deprecated devm_request_and_ioremap

Wolfram Sang (1):
  bus: brcmstb_gisb: Use devm_ioremap_resource

 Documentation/driver-model/devres.txt |  1 -
 drivers/bus/brcmstb_gisb.c            |  6 +++---
 drivers/gpu/drm/armada/armada_crtc.c  |  8 +++-----
 include/linux/device.h                |  2 --
 lib/devres.c                          | 28 ----------------------------
 5 files changed, 6 insertions(+), 39 deletions(-)

-- 
2.0.0

