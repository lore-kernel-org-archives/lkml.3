Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134Ab3DOST5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 14:19:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34878 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3DOST4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 14:19:56 -0400
Date: Mon, 15 Apr 2013 14:19:54 -0400 (EDT)
Message-Id: <20130415.141954.29857504310905187.davem@davemloft.net>
To: Valdis.Kletnieks@vt.edu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Query regarding PTP_1588_CLOCK
From: David Miller <davem@davemloft.net>
In-Reply-To: <38549.1366049778@turing-police.cc.vt.edu>
References: <38549.1366049778@turing-police.cc.vt.edu>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 15 Apr 2013 11:19:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Date: Mon, 15 Apr 2013 14:16:18 -0400

> In drivers/net/ethernet/intel/Kconfig, we see this:
> 
> config E1000E
>         tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
>         depends on PCI && (!SPARC32 || BROKEN)
>         select CRC32
>         select PTP_1588_CLOCK
>         ---help---
> 
> Is there a reason for the PTP_1588_CLOCK select?  That ends up
> forcing the PTP and PPS stuff into the kernel as well - and I don't
> use any of it.

You don't, but the driver does use it unconditionally.
