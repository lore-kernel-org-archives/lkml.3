Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaEIDm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:42:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33048 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaEIDm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:42:27 -0400
Date: Thu, 08 May 2014 23:42:25 -0400 (EDT)
Message-Id: <20140508.234225.1072761273005912123.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, amirv@mellanox.com, eli@mellanox.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH V2] mellanox: Logging message cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <eceba320507a1895ff8f1a5bd0b7a67839e7b7b0.1399492267.git.joe@perches.com>
References: <20140507.154108.567253192690937393.davem@davemloft.net>
	<eceba320507a1895ff8f1a5bd0b7a67839e7b7b0.1399492267.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 May 2014 20:42:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed,  7 May 2014 12:52:57 -0700

> Use a more current logging style.
> 
> o Coalesce formats
> o Add missing spaces for coalesced formats
> o Align arguments for modified formats
> o Add missing newlines for some logging messages
> o Use DRV_NAME as part of format instead of %s, DRV_NAME to
>   reduce overall text.
> o Use ..., ##__VA_ARGS__ instead of args... in macros
> o Correct a few format typos
> o Use a single line message where appropriate
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Acked-By: Amir Vadai <amirv@mellanox.com>

Applied, thanks.
