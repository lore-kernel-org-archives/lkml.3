Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaKCUe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:34:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49242 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaKCUez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:34:55 -0500
Date: Mon, 03 Nov 2014 15:34:53 -0500 (EST)
Message-Id: <20141103.153453.1235728189727221805.davem@davemloft.net>
To: sudipm.mukherjee@gmail.com
Cc: ajk@comnets.uni-bremen.de, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hamradio: 6pack: remove unnecessary check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415016749-6825-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415016749-6825-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Nov 2014 12:34:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Mon,  3 Nov 2014 17:42:29 +0530

> this is check for dev is unnecessary, as we are already checking dev
> after allocating it via alloc_netdev, and jumping to label: out
> if it is NULL.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Applied, thanks.
