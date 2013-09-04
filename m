Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266Ab3IDCLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:11:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53769 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934114Ab3IDCLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:11:16 -0400
Date: Tue, 03 Sep 2013 22:11:15 -0400 (EDT)
Message-Id: <20130903.221115.3505404468610766.davem@davemloft.net>
To: alonid@postram.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com
Subject: Re: [PATCH net-next] netconsole: avoid a crash with multiple sysfs
 writers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377860386-8494-1-git-send-email-alonid@postram.com>
References: <20130809062405.GA8031@neilslaptop.think-freely.org>
	<1377860386-8494-1-git-send-email-alonid@postram.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 03 Sep 2013 19:11:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Aloni <alonid@postram.com>
Date: Fri, 30 Aug 2013 13:59:46 +0300

> When my 'ifup eth' script was fired multiple times and ran concurrent on
> my laptop, for some obscure /etc scripting reason, it was revealed
> that the store_enabled() function in netconsole doesn't handle it nicely,
> as recorded by the Oops below (a syslog paste, but not mangled too much
> to prevent from discerning the traceback).
> 
> On Linux 3.10.4, this patch seeks to remedy the problem, and it has been
> running stable on my laptop for a few days.
 ...
> Signed-off-by: Dan Aloni <alonid@postram.com>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Applied, thanks.
