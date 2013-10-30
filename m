Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3J3WNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:13:48 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:59985 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab3J3WNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:13:47 -0400
X-Greylist: delayed 1954 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Oct 2013 18:13:46 EDT
Date: Wed, 30 Oct 2013 23:41:09 +0200 (EET)
From: mroos@linux.ee
To: Steffen Klassert <steffen.klassert@secunet.com>
cc: David Miller <davem@davemloft.net>, hannes@stressinduktion.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: 3.12-rc7 regression - network panic from ipv6
In-Reply-To: <20131030130945.GJ31491@secunet.com>
Message-ID: <alpine.SOC.1.00.1310302340170.24516@math.ut.ee>
References: <alpine.SOC.1.00.1310292221550.19416@math.ut.ee> <20131029210758.GA18323@order.stressinduktion.org> <alpine.SOC.1.00.1310292338010.22172@math.ut.ee> <20131029.174258.1677867676998240250.davem@davemloft.net> <20131030130945.GJ31491@secunet.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Works fine, thanks!

Tested-by: Meelis Roos <mroos@linux.ee>

-- 
Meelis Roos (mroos@linux.ee)
