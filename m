Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaLXQ4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:56:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55593 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaLXQ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:56:32 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8192ee: trx.c:  Remove unused function
References: <1419079694-32476-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 24 Dec 2014 18:56:23 +0200
In-Reply-To: <1419079694-32476-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 20 Dec 2014 13:48:14 +0100")
Message-ID: <87bnmt7zrc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> Remove the function rtl92ee_get_available_desc() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Thanks, applied to wireless-drivers-next.git.

But I simplified the patch title:

commit 9898b77536b8569be2704964d3c519ef070e4a27
Author: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date:   Sat Dec 20 13:48:14 2014 +0100

    rtlwifi: rtl8192ee: trx.c: Remove unused function

-- 
Kalle Valo
