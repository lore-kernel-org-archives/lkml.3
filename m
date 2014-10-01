Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaJATBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:01:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35395 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaJATBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:01:36 -0400
Date: Wed, 01 Oct 2014 15:01:33 -0400 (EDT)
Message-Id: <20141001.150133.82852657000649592.davem@davemloft.net>
To: michal.simek@xilinx.com
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        subbaraya.sundeep.bhatta@xilinx.com, manuel.schoelling@gmx.de,
        paul.gortmaker@windriver.com, Julia.Lawall@lip6.fr, joe@perches.com,
        ricardo.ribalda@gmail.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] net: ll_temac: Remove unnecessary ether_setup after
 alloc_etherdev
From: David Miller <davem@davemloft.net>
In-Reply-To: <909ad6e2f067c956a2bb89d848a2fc38fc605a08.1412154072.git.michal.simek@xilinx.com>
References: <909ad6e2f067c956a2bb89d848a2fc38fc605a08.1412154072.git.michal.simek@xilinx.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 12:01:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>
Date: Wed,  1 Oct 2014 11:01:17 +0200

> From: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
> 
> Calling ether_setup is redundant since alloc_etherdev calls it.
> 
> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
> Changes in v2:
> - Remove axienet because it is already applied in separate patch
>   https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/?id=c706471b2601d1c9058e7b866db77f6eb7dd37af

Applied, thanks Michal.
