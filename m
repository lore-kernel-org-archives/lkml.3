Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaKKRtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:49:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59626 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaKKRti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:49:38 -0500
Date: Tue, 11 Nov 2014 12:49:36 -0500 (EST)
Message-Id: <20141111.124936.272547351489598665.davem@davemloft.net>
To: johan@kernel.org
Cc: f.fainelli@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bth@kamstrup.dk
Subject: Re: [PATCH 00/22] net: phy: refactoring and Micrel features
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415727460-20417-1-git-send-email-johan@kernel.org>
References: <1415727460-20417-1-git-send-email-johan@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 09:49:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


22 patches is just too much, sorry.

Please reduce this down to something closer to ~10 or so patches.

If necessary you can do two series, submit the first 10 and then
when that's reviewed and accepted submit the second set.

Thanks.
