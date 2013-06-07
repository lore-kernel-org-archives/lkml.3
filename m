Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab3FGVsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 17:48:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48822 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab3FGVsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 17:48:09 -0400
Date: Fri, 07 Jun 2013 14:48:05 -0700 (PDT)
Message-Id: <20130607.144805.1227746282017227022.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        erdnetdev@gmail.com, bhutchings@solarflare.com, andi@firstfloor.org,
        hpa@zytor.com, eilong@broadcom.com, or.gerlitz@gmail.com,
        amirv@mellanox.com, eliezer@tamir.org.il
Subject: Re: [PATCH v9 net-next 0/7] net: low latency Ethernet device
 polling
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Wed, 05 Jun 2013 13:34:00 +0300

> And here is v9.
> Except for typo fixes in comments/description, only 2/7 and 5/7 were changed.
> 
> Thanks to everyone for their input.

Since there is some discussion about the way the poll() bits work,
might I suggest you make a v10 without the poll stuff, which I will
apply to net-next, and then you can build the poll stuff on top of
that?

Thanks!
