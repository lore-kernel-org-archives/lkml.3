Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3EaJc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:32:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35109 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3EaJcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:32:51 -0400
Date: Fri, 31 May 2013 02:32:50 -0700 (PDT)
Message-Id: <20130531.023250.1043552574744640563.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: buytenh@wantstofly.org, jason@lakedaemon.net, andrew@lunn.ch,
        benh@kernel.crashing.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/13] net: mv643xx_eth DT support and fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <51A8432A.4000602@gmail.com>
References: <1369855975-21489-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130530.175549.407800685811475192.davem@davemloft.net>
	<51A8432A.4000602@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Fri, 31 May 2013 08:28:58 +0200

> thanks for pulling these in. I finally found how to check if a patch
> already went into -stable. As Jason already said, the mdio patch that
> #1 fixes did not yet went into -stable. Can you unqueue it? Sorry for
> the confusion.

I'll unqueue it, thanks.
