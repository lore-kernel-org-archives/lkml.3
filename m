Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3I3L21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:28:27 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:54706 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3I3L2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:28:16 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the wireless-next tree
Date: Mon, 30 Sep 2013 13:26:13 +0200
Message-Id: <1380540373-25352-11-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380540373-25352-1-git-send-email-treding@nvidia.com>
References: <1380540373-25352-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the wireless-next tree got conflicts in

	drivers/net/wireless/rtlwifi/rtl8192ce/phy.h

I fixed it up (see below). Please check if the resolution looks correct.

Thanks,
Thierry
---
diff --cc drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
index f8973e5,80a0893..bb319b0
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@@ -217,10 -222,10 +215,9 @@@ void _rtl92ce_phy_lc_calibrate(struct i
  void rtl92c_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain);
  bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
  					  enum radio_path rfpath);
 -bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
 -					      u32 rfpath);
 +bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw, u32 rfpath);
- bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
  bool rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 -					  enum rf_pwrstate rfpwr_state);
 +				    enum rf_pwrstate rfpwr_state);
  void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
  bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
  void rtl92c_phy_set_io(struct ieee80211_hw *hw);
