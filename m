Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3H1VqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:46:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50172 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3H1VqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:46:24 -0400
Date: Wed, 28 Aug 2013 17:46:22 -0400 (EDT)
Message-Id: <20130828.174622.268609863849057534.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, eliezer@tamir.org.il
Subject: Re: [PATCH net] net: add cpu_relax to busy poll loop
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130825072346.31655.84970.stgit@ladj378.jer.intel.com>
References: <20130825072346.31655.84970.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 28 Aug 2013 14:46:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Sun, 25 Aug 2013 10:23:46 +0300

> Add a cpu_relaxt to sk_busy_loop.
> 
> Julie Cummings reported performance issues when hyperthreading is on.
> Arjan van de Ven observed that we should have a cpu_relax() in the
> busy poll loop.
> 
> Reported-by: Julie Cummings <julie.a.cummings@intel.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>

Applied, thank you.
