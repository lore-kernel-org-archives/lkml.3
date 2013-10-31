Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3JaEgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 00:36:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36724 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3JaEf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:35:58 -0400
Date: Thu, 31 Oct 2013 00:35:56 -0400 (EDT)
Message-Id: <20131031.003556.382419413730591963.davem@davemloft.net>
To: mroos@linux.ee
Cc: steffen.klassert@secunet.com, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 3.12-rc7 regression - network panic from ipv6
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1310302340170.24516@math.ut.ee>
References: <20131029.174258.1677867676998240250.davem@davemloft.net>
	<20131030130945.GJ31491@secunet.com>
	<alpine.SOC.1.00.1310302340170.24516@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 30 Oct 2013 21:35:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mroos@linux.ee
Date: Wed, 30 Oct 2013 23:41:09 +0200 (EET)

>> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> Works fine, thanks!
> 
> Tested-by: Meelis Roos <mroos@linux.ee>

Thanks for reporting the bug and testing the fix.
