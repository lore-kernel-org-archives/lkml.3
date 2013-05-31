Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab3EaVVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:21:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55880 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab3EaVV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:21:29 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <linux-kernel@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCH 0/3] minor cleanup fixes in remoteproc
Date: Fri, 31 May 2013 16:15:56 -0500
Message-ID: <1370034956-29531-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

These are minor cleanup patches in remoteproc code for v3.10, they are
fairly independent of each other.

Suman Anna (3):
  remoteproc: fix checkpatch errors in remoteproc code
  remoteproc/omap: fix a sparse warning
  remoteproc: free carveout memories only after unmapping them

 drivers/remoteproc/remoteproc_core.c          | 18 ++++++++++--------
 drivers/remoteproc/remoteproc_debugfs.c       |  3 +--
 drivers/remoteproc/remoteproc_internal.h      |  4 ++--
 include/linux/platform_data/remoteproc-omap.h |  2 +-
 4 files changed, 14 insertions(+), 13 deletions(-)

-- 
1.8.2

