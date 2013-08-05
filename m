Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3HESIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:08:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47503 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3HESIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:08:44 -0400
Date: Mon, 05 Aug 2013 11:08:43 -0700 (PDT)
Message-Id: <20130805.110843.938924468911400543.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/vmw_vsock/af_vsock.c: drop unneeded semicolon
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375714059-29567-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
	<1375714059-29567-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 05 Aug 2013 11:08:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Mon,  5 Aug 2013 16:47:38 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Drop the semicolon at the end of the list_for_each_entry loop header.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> Not tested, but I can't imagine how the current code could work, since vsk
> should end up pointing to a dummy value.

This bug has been there since the code was first checked in, and indeed
it's going to work on garbage since it's going to pass in the list
head transformed into a vsock structure.

Applied, thanks Julia.
