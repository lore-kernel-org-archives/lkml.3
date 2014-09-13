Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaIMVfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 17:35:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38353 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaIMVe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 17:34:59 -0400
Date: Sat, 13 Sep 2014 17:34:57 -0400 (EDT)
Message-Id: <20140913.173457.1906099694506405149.davem@davemloft.net>
To: alexandre.belloni@free-electrons.com
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        voice.shen@atmel.com
Subject: Re: [PATCHv2] net/macb: Add hardware revision information during
 probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410566269-16445-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410566269-16445-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Sep 2014 14:34:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Date: Sat, 13 Sep 2014 01:57:49 +0200

> From: Bo Shen <voice.shen@atmel.com>
> 
> Print the IP revision when probing.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Changes in v2:
>  - condense information on one line

Applied, thanks.
