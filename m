Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaBYWhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:37:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58318 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaBYWhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:37:16 -0500
Date: Tue, 25 Feb 2014 17:37:14 -0500 (EST)
Message-Id: <20140225.173714.863570499882066264.davem@davemloft.net>
To: joe@perches.com
Cc: ariele@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bnx2x: Remove hidden flow control goto from
 BNX2X_ALLOC macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392931551.2594.9.camel@joe-AO722>
References: <1392931551.2594.9.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2014 14:37:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 20 Feb 2014 13:25:51 -0800

> BNX2X_ALLOC macros use "goto alloc_mem_err"
> so these labels appear unused in some functions.
> 
> Expand these macros in-place via coccinelle and
> some typing.
> 
> Update the macros to use statement expressions
> and remove the BNX2X_ALLOC macro.
> 
> This adds some > 80 char lines.
 ...
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
