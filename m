Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3HEClm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 22:41:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38117 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3HEClk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 22:41:40 -0400
Date: Sun, 04 Aug 2013 19:41:39 -0700 (PDT)
Message-Id: <20130804.194139.1872286759580440582.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, eliezer@tamir.org.il
Subject: Re: [PATCH net] busy_poll: cleanup do-nothing placeholders
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130804095548.30006.8133.stgit@ladj378.jer.intel.com>
References: <20130804095548.30006.8133.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 04 Aug 2013 19:41:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Sun, 04 Aug 2013 12:55:48 +0300

> When renaming ll_poll to busy poll, I introduced a typo
> in the name of the do-nothing placeholder for sk_busy_loop
> and called it sk_busy_poll.
> This broke compile when busy poll was not configured.
> Cong Wang submitted a patch to fixed that.
> This patch removes the now redundant, misspelled placeholder.
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>

Applied, thanks.
