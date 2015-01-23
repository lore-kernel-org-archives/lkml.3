Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbbAWRbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:31:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37123 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbbAWRbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:31:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: rtlwifi/rtl8192de: remove redundant else if check
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421158054-22566-1-git-send-email-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20150123173101.2E01C1416F0@smtp.codeaurora.org>
Date: Fri, 23 Jan 2015 17:31:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Colin Ian King <colin.king@canonical.com>
> 
> The else if check condition checks for the opposite of the
> if check, hence the else if check is redundant and can be
> replaced with a simple else:
> 
> if (rtlpriv->rtlhal.macphymode == SINGLEMAC_SINGLEPHY) {
> 	..
> } else if (rtlpriv->rtlhal.macphymode != SINGLEMAC_SINGLEPHY) {
> 	..
> }
> 
> replaced with:
> 
> if (rtlpriv->rtlhal.macphymode == SINGLEMAC_SINGLEPHY) {
> 	..
> } else {
> 	..
> }
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
