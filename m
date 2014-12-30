Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaL3Xe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 18:34:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36631 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaL3Xe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 18:34:58 -0500
Date: Tue, 30 Dec 2014 18:34:55 -0500 (EST)
Message-Id: <20141230.183455.719651086250317259.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: bh74.an@samsung.com, kernel-janitors@vger.kernel.org, ks.giri@samsung.com,
        vipul.pandya@samsung.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/27] net: sxgbe: Use setup_timer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419604558-29743-16-git-send-email-Julia.Lawall@lip6.fr>
References: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
	<1419604558-29743-16-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Dec 2014 15:34:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Fri, 26 Dec 2014 15:35:46 +0100

> Convert a call to init_timer and accompanying intializations of
> the timer's data and function fields to a call to setup_timer.
> 
> A simplified version of the semantic match that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression t,f,d;
> @@
> 
> -init_timer(&t);
> +setup_timer(&t,f,d);
> -t.function = f;
> -t.data = d;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
