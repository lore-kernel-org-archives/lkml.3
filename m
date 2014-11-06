Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaKFUL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:11:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58303 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKFULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:11:51 -0500
Date: Thu, 06 Nov 2014 15:11:49 -0500 (EST)
Message-Id: <20141106.151149.1321164537677873976.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] sock.h: Remove unused NETDEBUG macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415230929.6634.38.camel@perches.com>
References: <1415230568.6634.36.camel@perches.com>
	<1415230929.6634.38.camel@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Nov 2014 12:11:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 05 Nov 2014 15:42:09 -0800

> It's unused now, just delete it.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks for doing this work Joe.
