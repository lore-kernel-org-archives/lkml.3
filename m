Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaGHAA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:00:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47715 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaGHAA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:00:56 -0400
Date: Mon, 07 Jul 2014 17:00:55 -0700 (PDT)
Message-Id: <20140707.170055.1999993887924074843.davem@davemloft.net>
To: himangi774@gmail.com
Cc: mareklindner@neomailbox.ch, sw@simonwunderlich.de, antonio@meshcoding.com,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] batman-adv: Use kasprintf
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140628183628.GA9946@himangi-Dell>
References: <20140628183628.GA9946@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Jul 2014 17:00:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Sun, 29 Jun 2014 00:06:29 +0530

> kasprintf combines kmalloc and sprintf, and takes care of the size
> calculation itself.
> 
> The semantic patch that makes this change is as follows:
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied, thanks.
