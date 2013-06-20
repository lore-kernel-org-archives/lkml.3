Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3FTGFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:05:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49996 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3FTGFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:05:47 -0400
Date: Wed, 19 Jun 2013 23:05:46 -0700 (PDT)
Message-Id: <20130619.230546.1612893804152231671.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH 2/9] PTR_RET is now PTR_ERR_OR_ZERO(): Replace most.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371357768-4968-2-git-send-email-rusty@rustcorp.com.au>
References: <87ehc2rczo.fsf@rustcorp.com.au>
	<1371357768-4968-1-git-send-email-rusty@rustcorp.com.au>
	<1371357768-4968-2-git-send-email-rusty@rustcorp.com.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 16 Jun 2013 14:12:41 +0930

> Sweep of the simple cases.
> 
> Cc: netdev@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: David S. Miller <davem@davemloft.net>
