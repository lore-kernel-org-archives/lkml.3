Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaAGFpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 00:45:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37597 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaAGFpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 00:45:54 -0500
Date: Tue, 07 Jan 2014 00:45:50 -0500 (EST)
Message-Id: <20140107.004550.1024697128774275576.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: correct some messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389064702-1173-1-git-send-email-hayeswang@realtek.com>
References: <1388999999-9218-1-git-send-email-hayeswang@realtek.com>
	<1389064702-1173-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 21:45:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 7 Jan 2014 11:18:22 +0800

>  - Replace pr_warn_ratelimited() with net_ratelimit() and netdev_warn().
>  - Adjust the algnment of some messages.
>  - Remove the peroid.
>  - Fix some messages don't have terminating newline.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

I only want major bug fixes in 'net' at this time so I've applied
this to 'net-next'.

Thanks.
