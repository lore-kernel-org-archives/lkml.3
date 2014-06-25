Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbaFYXPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:15:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39094 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbaFYXPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:15:35 -0400
Date: Wed, 25 Jun 2014 16:15:34 -0700 (PDT)
Message-Id: <20140625.161534.2268236653961314658.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        netdev@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH V2] net/dsa/dsa.c: remove unnecessary null test before
 kfree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403544767-12438-1-git-send-email-fabf@skynet.be>
References: <1403544767-12438-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Jun 2014 16:15:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 23 Jun 2014 19:32:47 +0200

> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: netdev@vger.kernel.org
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thanks.
