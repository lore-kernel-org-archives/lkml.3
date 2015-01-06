Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbbAFSOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:14:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37549 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbbAFSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:14:08 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rtlwifi: btcoexist: halbtc8821a2ant:  Remove some unused functions
References: <1420230361-1862-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 06 Jan 2015 20:14:01 +0200
In-Reply-To: <1420230361-1862-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Fri, 2 Jan 2015 21:26:01 +0100")
Message-ID: <871tn7zsie.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> Removes some functions that are not used anywhere:
> ex_halbtc8821a2ant_periodical() ex_halbtc8821a2ant_halt_notify()
> ex_halbtc8821a2ant_bt_info_notify()
> ex_halbtc8821a2ant_special_packet_notify()
> ex_halbtc8821a2ant_connect_notify() ex_halbtc8821a2ant_scan_notify()
> ex_halbtc8821a2ant_lps_notify() ex_halbtc8821a2ant_ips_notify()
> ex_halbtc8821a2ant_display_coex_info() ex_halbtc8821a2ant_init_coex_dm()
> ex_halbtc8821a2ant_init_hwconfig()
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Rickard, I have dropped all your patches because I lost track which I
should apply and which not and I do not want to waste half an hour
figuring out. Please resend the ones which are still valid.

And to make it easier for everyone please group these wireless-drivers
cleanup patches into a larger patchset (like 10-15 patches max per
patchset). That way it's a lot easier for me tomanage them. Sending one
patch a day is not recommended, especially when we are talking trivial
cleanup patches like this.

-- 
Kalle Valo
