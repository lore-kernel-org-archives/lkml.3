Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbaGaCOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:14:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38502 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaGaCOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:14:07 -0400
Date: Wed, 30 Jul 2014 19:14:05 -0700 (PDT)
Message-Id: <20140730.191405.497343033042623279.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: isdn@linux-pingi.de, kernel-janitors@vger.kernel.org,
        linux-ia64@vger.kernel.org, ceph-devel@vger.kernel.org,
        toralf.foerster@gmx.de, hmh@hmh.eng.br, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] CAPI: use correct structure type name in sizeof
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406647011-8543-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
	<1406647011-8543-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Jul 2014 19:14:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Tue, 29 Jul 2014 17:16:44 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Correct typo in the name of the type given to sizeof.  Because it is the
> size of a pointer that is wanted, the typo has no impact on compilation or
> execution.
> 
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).  The
> semantic patch used can be found in message 0 of this patch series.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Relatively harmless, so applied to net-next, thanks.
