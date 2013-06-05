Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3FEAe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 20:34:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60690 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3FEAeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 20:34:23 -0400
Date: Tue, 04 Jun 2013 17:34:22 -0700 (PDT)
Message-Id: <20130604.173422.570856682520942101.davem@davemloft.net>
To: maxime.ripard@free-electrons.com
Cc: arnd@arndb.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sr@denx.de, richard.genoud@gmail.com
Subject: Re: [PATCH] net: sun4i-emac: remove erroneous assignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130604134034.GE3283@lukather>
References: <3298610.K0DeJZEM4E@wuerfel>
	<20130604134034.GE3283@lukather>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>
Date: Tue, 4 Jun 2013 15:40:34 +0200

> On Mon, Jun 03, 2013 at 11:36:50PM +0200, Arnd Bergmann wrote:
>> The newly added sun4i-emac driver causes a build error when
>> CONFIG_NET_POLL_CONTROLLER is set, because it attempts to
>> assign a pointer to netdev->poll_controller, which has
>> been replaced with ops->ndo_poll_controller in 2.6.31!
>> 
>> The correct assignment is present as well, so we just need
>> to remove the wrong one.
> 
> Thanks for fixing this,
> Acked-by: Maxime Ripard <maxime.ripard@anandra.org>

Applied.
