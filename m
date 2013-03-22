Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921Ab3CVQQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:16:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54103 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704Ab3CVQQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:16:12 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v3 0/3] DT support for AS3711 MFD, regulator and backlight drivers
Date: Fri, 22 Mar 2013 17:15:46 +0100
Message-Id: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:qPAQF0UqdIHrBfqM74HPvek3wQ2sMEXmJUGwmwl4XM/
 PHIwTYbwc8Dkx1g+N1kuKauG/gAfadwtPQpvgXFAORHI2rvme7
 3krs0yOrnO5YMpIv5yypN3Fystbrgc6KYduVvuDNMJftlSxvIf
 9h89E5KR/lQJ7bwJZLCCUWLyyLs0Jrzb2X5geGhkKmZonR0yuB
 ca813Z5kX7Lj/UuqitCKcV+vJrNeFw5UC05vvRstEILGO7ZcSL
 Uohr0/7o+aG6Zg2BU89yFMLb3NsIFCkgl6d5IRdgWyPoTCG2dn
 85XjfNk4UJlIOXqHpp2D0ea3MCSSe64yxSdMeJQCoObV2gyutq
 32hRmbOVfZQfErfCZ0ybsMYVJcZ1dAuCSkut7MDANL+k7P2n4v
 /bgnyUxfx+1iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a split of the previous version of this patch(-set), no code 
changes.

Guennadi Liakhovetski (3):
  mfd: as3711: add OF support
  regulator: as3711: add OF support
  backlight: as3711: add OF support

 Documentation/devicetree/bindings/mfd/as3711.txt |   73 +++++++++++++
 drivers/mfd/as3711.c                             |   27 ++++-
 drivers/regulator/as3711-regulator.c             |   74 +++++++++++++-
 drivers/video/backlight/as3711_bl.c              |  118 +++++++++++++++++++++-
 4 files changed, 284 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/as3711.txt

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
