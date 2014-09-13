Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaIMCKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 22:10:31 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:62657 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaIMCK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 22:10:28 -0400
MIME-Version: 1.0
Date: Sat, 13 Sep 2014 10:10:26 +0800
Message-ID: <CAJKoSVTOzFjq=aZwzQC01AK=DmEDSK75ax+fUL=px96hhwibAQ@mail.gmail.com>
Subject: [PATCH] staging: rtl819x_TSProc.c: Initializer entry defined twice
From: Cheng-Wei Lee <lee.rhapsody@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        peter.p.waskiewicz.jr@intel.com, Joe Perches <joe@perches.com>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixs the sparse warning in rtl819x_TSProc.c:
drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c:244:58: warning:
Initializer entry defined twice
drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c:244:61:   also defined
here

Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
---
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
index c451410..acaa723 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
@@ -241,7 +241,7 @@ static PTS_COMMON_INFO SearchAdmitTRStream(struct
ieee80211_device *ieee,
 {
  //DIRECTION_VALUE dir;
  u8 dir;
- bool search_dir[4] = {0, 0, 0, 0};
+ bool search_dir[4] = {0};
  struct list_head *psearch_list; //FIXME
  PTS_COMMON_INFO pRet = NULL;
  if(ieee->iw_mode == IW_MODE_MASTER) //ap mode
-- 
1.7.9.5
