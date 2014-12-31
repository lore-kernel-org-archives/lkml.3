Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaLaAqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 19:46:46 -0500
Received: from smtp.infotech.no ([82.134.31.41]:42430 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbaLaAqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 19:46:45 -0500
Message-ID: <54A34769.6060002@interlog.com>
Date: Tue, 30 Dec 2014 19:46:33 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: lk3.19.0-rc2: no cfg80211 wireless extensions compatibility
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was there a good reason for this change in net/wireless/Kconfig
between lk 3.18 and 3.19-rc2 ??

--- /tmp/Kconfig	2014-12-25 13:46:28.802185089 -0500
+++ ./Kconfig	2014-12-30 18:08:15.539337145 -0500
@@ -175,7 +175,7 @@
  	  Most distributions have a CRDA package.  So if unsure, say N.

  config CFG80211_WEXT
-	bool "cfg80211 wireless extensions compatibility"
+	bool
  	depends on CFG80211
  	select WEXT_CORE
  	help


That change makes it pretty hard for folks who need those extensions.

Doug Gilbert
