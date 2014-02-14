Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaBNVVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:21:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38331 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaBNVVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:21:03 -0500
Date: Fri, 14 Feb 2014 16:21:01 -0500 (EST)
Message-Id: <20140214.162101.359269415805856434.davem@davemloft.net>
To: bitbucket@online.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] net,bonding: fix bond_options.c direct rwlock.h include
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392362464.5579.41.camel@marge.simpson.net>
References: <1392362464.5579.41.camel@marge.simpson.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2014 13:21:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <bitbucket@online.de>
Date: Fri, 14 Feb 2014 08:21:04 +0100

> drivers/net/bonding/bond_options.c includes rwlock.h directly,
> which is a nono, and which also breaks RT kernel build.
> 
> Signed-off-by: Mike Galbraith <bitbucket@online.de>

Applied, thank you.
