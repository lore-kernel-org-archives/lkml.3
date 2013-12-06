Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab3LFUWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:22:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42169 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3LFUW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:22:29 -0500
Date: Fri, 06 Dec 2013 15:22:27 -0500 (EST)
Message-Id: <20131206.152227.1496961403659620861.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH v4 net-next 0/4] net: some cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386360786-17687-1-git-send-email-zwu.kernel@gmail.com>
References: <1386360786-17687-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 12:22:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <zwu.kernel@gmail.com>
Date: Sat,  7 Dec 2013 04:13:02 +0800

> Since net-next is open now, it's time to post them out again.
> 
> Changelog from v3:
>  -combine the change that removes the return value check with
> the change which adjusts the function return type to "void". [David Miller]

Looks good, series applied, thanks.
