Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaBRUUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:20:36 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46612
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaBRUUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:20:35 -0500
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH 0/2] Re-sending two patches for hyperv_fb
Date: Tue, 18 Feb 2014 13:11:29 -0800
Message-Id: <1392757891-28680-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They were sent out during tree closing, I'm re-sending them now.

Haiyang Zhang (2):
  hyperv_fb: Add screen refresh after pause/resume operation
  hyperv_fb: Add support for Gen2 VM

 drivers/video/hyperv_fb.c |   70 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 50 insertions(+), 20 deletions(-)

-- 
1.7.4.1

