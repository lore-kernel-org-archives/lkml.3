Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaFYXcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:32:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39186 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaFYXcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:32:31 -0400
Date: Wed, 25 Jun 2014 16:32:30 -0700 (PDT)
Message-Id: <20140625.163230.90574954824917070.davem@davemloft.net>
To: joe@perches.com
Cc: pcnet32@frontier.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] amd: Neaten and remove unnecessary OOM messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403559395.20657.8.camel@joe-AO725>
References: <1403550950.15811.15.camel@joe-AO725>
	<1403557507.20657.3.camel@joe-AO725>
	<1403559395.20657.8.camel@joe-AO725>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Jun 2014 16:32:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 23 Jun 2014 14:36:35 -0700

> Make the code flow a little better for 80 columns.
> 
> Use a consistent style for the RX and TX rings allocation.
> Use BIT macro.
> Use a temporary unsiged int entries for (1<<size).
> Remove the OOM messages as they duplicate the generic
> OOM and dump_stack() provided by the memory subsystem.
> Reflow allocs to 80 columns.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Please repost with adjusted subject prefix (amd --> pcnet32), thanks.
