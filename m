Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3LKD5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:57:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54237 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3LKD5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:57:14 -0500
Date: Tue, 10 Dec 2013 22:57:12 -0500 (EST)
Message-Id: <20131210.225712.1516913784424835912.davem@davemloft.net>
To: soren.brinkmann@xilinx.com
Cc: nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, michal.simek@xilinx.com
Subject: Re: [PATCH v2 0/5] net: macb updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386720443-24100-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1386720443-24100-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 10 Dec 2013 19:57:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Soren Brinkmann <soren.brinkmann@xilinx.com>
Date: Tue, 10 Dec 2013 16:07:18 -0800

> I'd really like to have Ethernet working for Zynq, so I want to at least
> revive this discussion regarding this patchset. And the first four
> patches should not even be too controversial.
> I didn't change anything compared to my original RFC submission, except
> for a typo in one of the commit messages.
> Handling the tx_clk as optional clock input seems a little bit weird,
> but it works on my Zynq platform and should be compatible with other
> users of macb and their DT descriptions.

Series applied to net-next, thanks.
