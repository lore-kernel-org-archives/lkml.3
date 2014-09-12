Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaILVTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:19:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51232 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaILVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:19:31 -0400
Date: Fri, 12 Sep 2014 17:19:27 -0400 (EDT)
Message-Id: <20140912.171927.1101339364255601150.davem@davemloft.net>
To: b.galvani@gmail.com
Cc: romain.perier@gmail.com, heiko@sntech.de, arnd@arndb.de,
        tklauser@distanz.ch, jg1.han@samsung.com, max.schwarz@online.de,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] net: arc_emac: fix tx issues
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410382203-10395-1-git-send-email-b.galvani@gmail.com>
References: <1410382203-10395-1-git-send-email-b.galvani@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Sep 2014 14:19:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Beniamino Galvani <b.galvani@gmail.com>
Date: Wed, 10 Sep 2014 22:50:01 +0200

> the patches below solve some issues found in the tx ring reclaim
> strategy currently implemented in the arc_emac driver.
> 
> Without these patches a simple outgoing UDP flow blocks almost
> immediately with the socket send buffer full, until some new rx
> packets trigger a clean of the tx ring.
> 
> Everything seems to work fine on a Radxa Rock with this fix applied.

Series applied, thanks.
