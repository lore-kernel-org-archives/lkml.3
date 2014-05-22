Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaEVT2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:28:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41771 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaEVT2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:28:11 -0400
Date: Thu, 22 May 2014 15:28:08 -0400 (EDT)
Message-Id: <20140522.152808.802269502342645717.davem@davemloft.net>
To: amirv@mellanox.com
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bhutchings@solarflare.com, yevgenyp@mellanox.com,
        ogerlitz@mellanox.com, eyalpe@mellanox.com
Subject: Re: [PATCH net-next] genirq: Eliminate explicit dependency between
 IRQ affinity notifiers and CONFIG_SMP
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400597820-30685-1-git-send-email-amirv@mellanox.com>
References: <1400597820-30685-1-git-send-email-amirv@mellanox.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 12:28:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Vadai <amirv@mellanox.com>
Date: Tue, 20 May 2014 17:57:00 +0300

> From: Eyal Perry <eyalpe@mellanox.com>
> 
> Instead of requiring each consumer of the IRQ affinity notifier to have
> themselves be explicitly dependent on CONFIG_SMP, make the definition of
> struct irq_affinity_notify to exist independently of that config option
> and introduce a stub for irq_set_affinity_notifier() under non SMP
> configuration.
> 
> Fixes: 2eacc23 ("net/mlx4_core: Enforce irq affinity changes
> immediatly")
> 
> Signed-off-by: Eyal Perry <eyalpe@mellanox.com>
> Signed-off-by: Amir Vadai <amirv@mellanox.com>

IRQ layer folks please review and push upstream if there aren't any
problems.

Thanks.
