Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaGHXWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:22:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55019 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaGHXWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:22:05 -0400
Date: Tue, 08 Jul 2014 16:22:04 -0700 (PDT)
Message-Id: <20140708.162204.1648218023530822781.davem@davemloft.net>
To: himangi774@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] iaf_packet: use BUG_ON
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140708222023.GA11829@himangi-Dell>
References: <20140708222023.GA11829@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 16:22:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Wed, 9 Jul 2014 03:50:23 +0530

> Use BUG_ON(x) rather than if(x) BUG();
> 
> The semantic patch that fixes this problem is as follows:
> 
> // <smpl>
> @@ identifier x; @@
> -if (x) BUG();
> +BUG_ON(x);
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Please repost this with a proper subject line, correcting "iaf_packet".

