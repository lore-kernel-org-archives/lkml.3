Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbbAEJRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:17:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56077 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbbAEJRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:17:09 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Giel van Schijndel <me@mortis.eu>
Cc: linux-kernel@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] Align member-assigns in a structure-copy block
References: <1420394427-19509-1-git-send-email-me@mortis.eu>
Date: Mon, 05 Jan 2015 11:16:59 +0200
In-Reply-To: <1420394427-19509-1-git-send-email-me@mortis.eu> (Giel van
	Schijndel's message of "Sun, 4 Jan 2015 19:00:22 +0100")
Message-ID: <87bnmd4mes.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giel van Schijndel <me@mortis.eu> writes:

> This highlights the differences (errors).
> ---
>  drivers/net/wireless/ti/wlcore/acx.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)

Please prefix the patch titles with "wlcore: ".

-- 
Kalle Valo
