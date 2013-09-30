Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3I3O0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:26:19 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:37765 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3I3O0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:26:18 -0400
Message-ID: <52498A07.1050800@lwfinger.net>
Date: Mon, 30 Sep 2013 09:26:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the wireless-next tree
References: <1380540373-25352-1-git-send-email-treding@nvidia.com> <1380540373-25352-11-git-send-email-treding@nvidia.com>
In-Reply-To: <1380540373-25352-11-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 06:26 AM, Thierry Reding wrote:
> Today's linux-next merge of the wireless-next tree got conflicts in
>
> 	drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
>
> I fixed it up (see below). Please check if the resolution looks correct.
>
> Thanks,
> Thierry
> ---
> diff --cc drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
> index f8973e5,80a0893..bb319b0
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
> @@@ -217,10 -222,10 +215,9 @@@ void _rtl92ce_phy_lc_calibrate(struct i
>    void rtl92c_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain);
>    bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
>    					  enum radio_path rfpath);
>   -bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
>   -					      u32 rfpath);
>   +bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw, u32 rfpath);
> - bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
>    bool rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
>   -					  enum rf_pwrstate rfpwr_state);
>   +				    enum rf_pwrstate rfpwr_state);
>    void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
>    bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
>    void rtl92c_phy_set_io(struct ieee80211_hw *hw);

Thierry,

Yes, your fix is correct.

Larry


