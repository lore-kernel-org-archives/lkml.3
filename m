Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaLZWIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 17:08:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40803 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaLZWIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 17:08:14 -0500
Date: Fri, 26 Dec 2014 17:08:11 -0500 (EST)
Message-Id: <20141226.170811.464811931780644413.davem@davemloft.net>
To: der.herr@hofr.at
Cc: rasesh.mody@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: incorrect use of init_completion fixup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419356870-22710-1-git-send-email-der.herr@hofr.at>
References: <1419356870-22710-1-git-send-email-der.herr@hofr.at>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Dec 2014 14:08:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Mc Guire <der.herr@hofr.at>
Date: Tue, 23 Dec 2014 18:47:50 +0100

> The second init_completion call should be a reinit_completion here.
> 
> patch is against 3.18.0 linux-next
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Applied, thanks.
