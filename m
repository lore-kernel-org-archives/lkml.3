Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaLXQ7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:59:41 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55670 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaLXQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:59:39 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8723be: phy.c:  Remove unused function
References: <1419116358-13223-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 24 Dec 2014 18:59:31 +0200
In-Reply-To: <1419116358-13223-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 20 Dec 2014 23:59:18 +0100")
Message-ID: <877fxh7zm4.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> Remove the function rtl8723be_phy_get_txpower_level() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
