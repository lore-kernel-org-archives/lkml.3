Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaEIOQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:16:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46281 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755997AbaEIOQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:16:46 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [RFC PATCH 0/2] drm/panel: add simple-panel description using DT
Date: Fri,  9 May 2014 16:16:40 +0200
Message-Id: <1399645002-18000-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thierry,

I noticed you're describing each new panel with a new entry in the
of_platform_match table and a new compatible string.
I guess you have a good reason to do it this way, because retrieving
panel description from DT would be pretty easy (see this series ;-)).

Could tell me why you chose this approach ?

Best Regards,

Boris

Boris BREZILLON (2):
  drm/panel: add support for simple-panel description definition using
    DT
  drm/panel: update simple-panel DT bindings doc with panel desc
    properties

 .../devicetree/bindings/panel/simple-panel.txt     | 34 +++++++++++
 drivers/gpu/drm/panel/Kconfig                      |  1 +
 drivers/gpu/drm/panel/panel-simple.c               | 70 ++++++++++++++++++++++
 3 files changed, 105 insertions(+)

-- 
1.8.3.2

