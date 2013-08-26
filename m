Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3HZUE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:04:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41172 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3HZUEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:04:54 -0400
Date: Mon, 26 Aug 2013 16:04:50 -0400 (EDT)
Message-Id: <20130826.160450.2176892065062148718.davem@davemloft.net>
To: b.brezillon@overkiz.com
Cc: nicolas.ferre@atmel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        linux@arm.linux.org.uk, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 0/2] net/cadence/macb: add support for dt phy definition
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377186980-21902-1-git-send-email-b.brezillon@overkiz.com>
References: <1377186980-21902-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 26 Aug 2013 13:04:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <b.brezillon@overkiz.com>
Date: Thu, 22 Aug 2013 17:56:20 +0200

> This patch series adds support for ethernet phy definition using device
> tree.
> 
> This may help in moving some at91 boards to dt (some of them define an
> interrupt pin).
> 
> Tested on samad31ek.

Series applied to net-next, thanks.
