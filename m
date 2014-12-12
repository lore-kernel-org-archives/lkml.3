Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119AbaLLUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:16:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38099 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033AbaLLUQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:16:28 -0500
Date: Fri, 12 Dec 2014 15:16:26 -0500 (EST)
Message-Id: <20141212.151626.1534262330967192209.davem@davemloft.net>
To: lambert.quentin@gmail.com
Cc: cooldavid@cooldavid.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Remove redundant function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141212123432.GA12765@sloth>
References: <20141212123432.GA12765@sloth>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Dec 2014 12:16:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Quentin Lambert <lambert.quentin@gmail.com>
Date: Fri, 12 Dec 2014 13:34:32 +0100

> tasklet_hi_enable and tasklet_enable are redundant. Since
> tasklet_hi_enable is used only 6 times in 1 file, the first
> patch changes calls to the function with calls to tasklet_enable.
> 
> The second patch removes tasklet_hi_enable definition.

This is pretty simple and straightforward, so I hope nobody minds
my merging this via my networking tree.

Series applied, thanks.
