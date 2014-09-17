Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbaIQTAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:00:51 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:37567 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755786AbaIQTAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:00:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkNAL/ZGVRXQCIg/2dsb2JhbABhgw22CgsFAXABmxeBFxcBeYRgI4EaiHkBv3+GCYluHYQ1BYYflm2MMokWg2A7gnkBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: daniel.vetter@intel.com, Fabian Frederick <fabf@skynet.be>,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH 0/6] video: fbdev: use container_of where possible
Date: Wed, 17 Sep 2014 21:00:13 +0200
Message-Id: <1410980419-5326-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small patchset using container_of instead of casting on first structure member address.

Fabian Frederick (6):
  video: fbdev: stifb.c: use container_of to resolve stifb_info from fb_info
  video: fbdev: sa1100fb.c: use container_of to resolve sa1100fb_info from fb_info
  video: fbdev: controlfb.c: use container_of to resolve fb_info_control from fb_info
  video: fbdev: cyber2000fb.c: use container_of to resolve cfb_info from fb_info
  video: fbdev: pxafb.c: use container_of to resolve pxafb_info/layer from fb_info
  video: fbdev: valkyriefb.c: use container_of to resolve fb_info_valkyrie from fb_info

 drivers/video/fbdev/controlfb.c   | 15 ++++++++++-----
 drivers/video/fbdev/cyber2000fb.c | 16 ++++++++--------
 drivers/video/fbdev/pxafb.c       | 20 ++++++++++----------
 drivers/video/fbdev/sa1100fb.c    | 18 ++++++++++++------
 drivers/video/fbdev/stifb.c       |  4 ++--
 drivers/video/fbdev/valkyriefb.c  | 12 ++++++++----
 6 files changed, 50 insertions(+), 35 deletions(-)

-- 
2.1.0

