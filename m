Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbaAITpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:45:39 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56683 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbaAITp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:45:27 -0500
From: Anmol Sarma <me@anmolsarma.in>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, Anmol Sarma <me@anmolsarma.in>
Subject: [PATCH v2 0/3] Staging: rtl8187se: Sparse fixes
Date: Fri, 10 Jan 2014 01:14:41 +0530
Message-Id: <cover.1389295289.git.me@anmolsarma.in>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140109151518.GS30234@mwanda>
References: <20140109151518.GS30234@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warnings for undeclared symbols not marked static.

Anmol Sarma (3):
  Staging: rtl8187se: r8180_core.c: mark symbols as static
  Staging: rtl8187se: r8180_wx.c: make 'rtl8180_rates' static
  Staging: rtl8187se: ieee80211: ieee80211_softmac.c: mark symbols as
    static

 .../rtl8187se/ieee80211/ieee80211_softmac.c        | 74 +++++++++++-----------
 drivers/staging/rtl8187se/r8180_core.c             | 14 ++--
 drivers/staging/rtl8187se/r8180_wx.c               |  2 +-
 3 files changed, 45 insertions(+), 45 deletions(-)

-- 
1.8.3.2

