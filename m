Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968282Ab3HISjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:39:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49960 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967943Ab3HISjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:39:41 -0400
Date: Fri, 09 Aug 2013 11:39:40 -0700 (PDT)
Message-Id: <20130809.113940.187893351073333334.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: sbohrer@rgmadvisors.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, eliezer@tamir.org.il
Subject: Re: [PATCH net v2] net: rename busy poll MIB counter
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130807083324.27322.99300.stgit@ladj378.jer.intel.com>
References: <20130807083324.27322.99300.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 09 Aug 2013 11:39:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Wed, 07 Aug 2013 11:33:25 +0300

> Rename mib counter from "low latency" to "busy poll"
> 
> v1 also moved the counter to the ip MIB (suggested by Shawn Bohrer)
> Eric Dumazet suggested that the current location is better.
> 
> So v2 just renames the counter to fit the new naming convention.
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>

Applied, thanks.
