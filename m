Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3IXOCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:02:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53109 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3IXOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:02:13 -0400
Date: Tue, 24 Sep 2013 10:02:09 -0400 (EDT)
Message-Id: <20130924.100209.1219862004963547693.davem@davemloft.net>
To: mkl@pengutronix.de
Cc: joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wg@grandegger.com, linux-can@vger.kernel.org
Subject: Re: [PATCH 01/10] can: Remove extern from function prototypes
From: David Miller <davem@davemloft.net>
In-Reply-To: <52414128.8030706@pengutronix.de>
References: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
	<52414128.8030706@pengutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 24 Sep 2013 07:02:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Tue, 24 Sep 2013 09:37:12 +0200

> On 09/24/2013 12:11 AM, Joe Perches wrote:
>> There are a mix of function prototypes with and without extern
>> in the kernel sources.  Standardize on not using extern for
>> function prototypes.
>> 
>> Function prototypes don't need to be written with extern.
>> extern is assumed by the compiler.  Its use is as unnecessary as
>> using auto to declare automatic/local variables in a block.
>> 
>> Signed-off-by: Joe Perches <joe@perches.com>
> 
> Thx, added to linux-can-next. The patch will be included in the next
> pull request to David.

Marc, I'm trying to just quickly apply these all into my tree directly.

Thanks.
