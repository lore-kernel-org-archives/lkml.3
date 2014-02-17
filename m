Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaBQTNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:13:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50370 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaBQTND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:13:03 -0500
Date: Mon, 17 Feb 2014 14:13:01 -0500 (EST)
Message-Id: <20140217.141301.1570178529590936114.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: tytso@mit.edu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION v3.14-rc2] NULL dereference in icmp6_send()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140217185053.GF22833@order.stressinduktion.org>
References: <nsxzjlp4lxm.fsf@closure.thunk.org>
	<20140217185053.GF22833@order.stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2014 11:13:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Mon, 17 Feb 2014 19:50:53 +0100

> At that point the skb does not have a dst attached, so we panic in
> icmp6_send.
> 
> This is fixed here:
> https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=d94c1f92bbf2c42c5febd68bbea51fffeac90834

Yep I'll get this to Linus soon.
