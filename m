Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbbAONtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:49:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33602 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbbAONtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:49:41 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Masanari Iida <standby24x7@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] rtlwifi: btcoexist: Remove some unused functions
References: <1420907079-27102-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54B15D57.5060709@lwfinger.net>
Date: Thu, 15 Jan 2015 15:49:33 +0200
In-Reply-To: <54B15D57.5060709@lwfinger.net> (Larry Finger's message of "Sat,
	10 Jan 2015 11:11:51 -0600")
Message-ID: <87twzsnogi.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 01/10/2015 10:24 AM, Rickard Strandqvist wrote:
>> Removes some functions that are not used anywhere:
>> ex_halbtc8821a1ant_periodical() ex_halbtc8821a1ant_pnp_notify()
>> ex_halbtc8821a1ant_halt_notify() ex_halbtc8821a1ant_bt_info_notify()
>> ex_halbtc8821a1ant_special_packet_notify() ex_halbtc8821a1ant_connect_notify()
>> ex_halbtc8821a1ant_scan_notify() ex_halbtc8821a1ant_lps_notify()
>> ex_halbtc8821a1ant_ips_notify() ex_halbtc8821a1ant_display_coex_info()
>> ex_halbtc8821a1ant_init_coex_dm() ex_halbtc8821a1ant_init_hwconfig()
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> NACK!!!!!!!!!
>
> I told you to stay away from these routines until I finish my update.
> Not only might you remove some functions that I will be needing later,
> but you run the risk of merge complications.
>
> Kalle: Please ignore EVERYTHING from this person. Obviously, he is
> incapable of understanding even the simplest instructions.

Yeah, I have to agree with that. I think he is just too fixated creating
the patches automatically.

I have dropped the patches.

-- 
Kalle Valo
