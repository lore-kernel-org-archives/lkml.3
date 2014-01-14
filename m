Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaANFQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:16:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40825 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaANFQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:16:22 -0500
Date: Mon, 13 Jan 2014 21:16:19 -0800 (PST)
Message-Id: <20140113.211619.613683326137425186.davem@davemloft.net>
To: dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        saidi@engin.umich.edu, jmorris@namei.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, davej@redhat.com, ncardwell@google.com,
        kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] net_dma: revert 'copied_early'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140114004637.27138.50365.stgit@viggo.jf.intel.com>
References: <20140114004509.27138.50345.stgit@viggo.jf.intel.com>
	<20140114004637.27138.50365.stgit@viggo.jf.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Jan 2014 16:47:14 -0800

> Now that tcp_dma_try_early_copy() is gone nothing ever sets
> copied_early.
> 
> Also reverts "53240c208776 tcp: Fix possible double-ack w/ user dma"
> since it is no longer necessary.
> 
> Cc: Ali Saidi <saidi@engin.umich.edu>
> Cc: James Morris <jmorris@namei.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Neal Cardwell <ncardwell@google.com>
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
