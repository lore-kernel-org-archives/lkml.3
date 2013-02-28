Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357Ab3B1UkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:40:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47891 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760338Ab3B1UkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:40:10 -0500
Date: Thu, 28 Feb 2013 15:40:08 -0500 (EST)
Message-Id: <20130228.154008.346192838829971364.davem@davemloft.net>
To: ikosar@fit.vutbr.cz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net/phy: micrel: Disable asymmetric pause for
 KSZ9021
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362077122-4266-1-git-send-email-ikosar@fit.vutbr.cz>
References: <1362077122-4266-1-git-send-email-ikosar@fit.vutbr.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 28 Feb 2013 12:40:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlastimil Kosar <ikosar@fit.vutbr.cz>
Date: Thu, 28 Feb 2013 19:45:22 +0100

> Phyter KSZ9021 has hardware bug. If asymmetric pause is enabled,
> then it is necessary to disconnect and then reconnect the ethernet
> cable to get the phyter working. The solution is to disable the
> asymmetric pause.
> 
> Signed-off-by: Vlastimil Kosar <ikosar@fit.vutbr.cz>

Applied, thanks.
