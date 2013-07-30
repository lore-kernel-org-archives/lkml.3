Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab3G3HKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:10:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58203 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3G3HKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:10:02 -0400
Date: Tue, 30 Jul 2013 00:10:01 -0700 (PDT)
Message-Id: <20130730.001001.618776305200728182.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH - diffstat only] include/net: Remove extern from
 function prototypes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374602291.3387.17.camel@joe-AO722>
References: <1374602291.3387.17.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 00:10:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 23 Jul 2013 10:58:11 -0700

> Function prototypes don't need to be declared
> extern in .h files.  It's assumed by the compiler
> and is as unnecessary as using auto is when
> declaring automatic/local variables in a block.
> 
> I ran a script to remove these unnecessary extern
> uses from function prototypes in include/net/ as
> well as reflow the function arguments to 80 cols.
> 
> It's 370KB, far too large to submit at once.
> 
> Of course it could be broken into multiple patches
> for the various directories/subsystems.

No objections from me.

Please submit a small number at a time so that my already overflowing
backlog isn't overwhelmed even more.

Thanks.
