Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaLXPXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 10:23:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53245 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaLXPXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 10:23:10 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8192de: fw.c:  Remove unused function
References: <1417989613-18300-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 24 Dec 2014 17:23:01 +0200
In-Reply-To: <1417989613-18300-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sun, 7 Dec 2014 23:00:13 +0100")
Message-ID: <871tnp9ine.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> Remove the function rtl92d_set_fw_pwrmode_cmd() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Thanks, applied to wireless-drivers-next.git.

But in the future, to make my work easier, please simplify your patch
titles. You do not have to put the full directory structure there. I now
manually changed it to:

commit 18e0c0bf3a5ea0f54384149570274d535341dc06
Author: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date:   Sun Dec 7 23:00:13 2014 +0100

    rtlwifi: rtl8192de: fw.c: Remove unused function

Most important is that the title begins with the name of the driver
(rtlwifi, iwlwifi, ath9k and so on) and is not too long. That way it's a
lot easier for me and Johannes to manage the wireless patches in
patchwork.

-- 
Kalle Valo
