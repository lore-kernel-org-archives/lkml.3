Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbbAFSlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:41:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40067 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbbAFSlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:41:50 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 11/28] net: wireless: ath: ath5k: drop owner assignment from platform_drivers
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
	<1419196495-9626-12-git-send-email-wsa@the-dreams.de>
Date: Tue, 06 Jan 2015 20:41:41 +0200
In-Reply-To: <1419196495-9626-12-git-send-email-wsa@the-dreams.de> (Wolfram
	Sang's message of "Sun, 21 Dec 2014 22:14:32 +0100")
Message-ID: <87bnmbycnu.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang <wsa@the-dreams.de> writes:

> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Generated with coccinelle. SmPL file is in the introductory msg. The big
> cleanup was pulled in this merge window. This series catches the bits fallen
> through. The patches shall go in via the subsystem trees.

Thanks, applied to wireless-drivers-next.git. But I simplified the patch
title:

c0c3163a7213 ath5k: drop owner assignment from platform_drivers

-- 
Kalle Valo
