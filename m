Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaIJDhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:37:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35615 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaIJDhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:37:33 -0400
Date: Tue, 09 Sep 2014 20:37:32 -0700 (PDT)
Message-Id: <20140909.203732.1451216065011764152.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net: Convert remaining uses of
 pr_warning to pr_warn
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410319664.24028.6.camel@joe-AO725>
References: <1410319664.24028.6.camel@joe-AO725>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 20:37:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 09 Sep 2014 20:27:44 -0700

> Use the much more common pr_warn instead of pr_warning.
> 
> Other miscellanea:
> 
> o Typo fixes submiting/submitting
> o Coalesce formats
> o Realign arguments
> o Add missing terminating '\n' to formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> Most of these are old drivers so I'm not cc'ing everyone.
> Let me know if you want these separated or simply dropped.
> 
> This does add a long line for a coalesced variable.
> I think it reads better whole than in pieces.

Applied, thanks.
