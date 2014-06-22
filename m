Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaFVCWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 22:22:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41041 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFVCWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 22:22:44 -0400
Date: Sat, 21 Jun 2014 19:22:43 -0700 (PDT)
Message-Id: <20140621.192243.435372238194944118.davem@davemloft.net>
To: joe@perches.com
Cc: fabf@skynet.be, bjorn@mork.no, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net/dsa/dsa.c: remove null test before kfree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403359806.4076.50.camel@joe-AO725>
References: <b991e868-c253-4b1a-8c95-56106c36d512@email.android.com>
	<20140621113653.6b2dd148b35a6ecfb7c08cce@skynet.be>
	<1403359806.4076.50.camel@joe-AO725>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Jun 2014 19:22:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 21 Jun 2014 07:10:06 -0700

> In this case, it seems the simple substitution of
> "unnecessary null" to the subject would have been
> enough validation.

Agreed.
