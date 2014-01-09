Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaAILRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:17:01 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60206 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbaAILLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:11:47 -0500
From: me@anmolsarma.in
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anmol Sarma <me@anmolsarma.in>
Subject: [PATCH 0/3] Staging: rtl8187se: Sparse fixes
Date: Thu,  9 Jan 2014 16:41:04 +0530
Message-Id: <cover.1389263965.git.me@anmolsarma.in>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anmol Sarma <me@anmolsarma.in>

Fix sparse warnings for undeclared symbols not marked static.

Anmol Sarma (3):
  Staging: rtl8187se: r8180_core.c: mark symbols as static
  Staging: rtl8187se: r8180_wx.c: mark symbols as static
  Staging: rtl8187se: ieee80211: ieee80211_softmac.c: mark symbols as
    static

 .../rtl8187se/ieee80211/ieee80211_softmac.c        | 74 +++++++++++-----------
 drivers/staging/rtl8187se/r8180_core.c             | 14 ++--
 drivers/staging/rtl8187se/r8180_wx.c               |  2 +-
 3 files changed, 45 insertions(+), 45 deletions(-)

-- 
1.8.3.2

