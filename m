Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3AQUFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:05:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52790 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3AQUFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:05:04 -0500
Date: Thu, 17 Jan 2013 15:05:02 -0500 (EST)
Message-Id: <20130117.150502.1981147330754808185.davem@davemloft.net>
To: nickolai@csail.mit.edu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 3c574_cs: fix operator precedence between << and &
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358443109-63402-1-git-send-email-nickolai@csail.mit.edu>
References: <1358443109-63402-1-git-send-email-nickolai@csail.mit.edu>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Thu, 17 Jan 2013 12:18:29 -0500

> The code to print the FIFO size in tc574_config computes it as:
> 
>   8 << config & Ram_size
> 
> which evaluates the '<<' first, but the actual intent is to evaluate the
> '&' first.  Add parentheses to enforce desired evaluation order.
> 
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>

Applied.
