Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaCGUlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:41:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43237 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaCGUlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:41:45 -0500
Date: Fri, 07 Mar 2014 15:41:42 -0500 (EST)
Message-Id: <20140307.154142.488351276799532264.davem@davemloft.net>
To: alistair@popple.id.au
Cc: netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/5] IBM Akebono: Add support for a new PHY interface
 to the IBM emac driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394077948-8395-3-git-send-email-alistair@popple.id.au>
References: <1394077948-8395-1-git-send-email-alistair@popple.id.au>
	<1394077948-8395-3-git-send-email-alistair@popple.id.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Mar 2014 12:41:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alistair Popple <alistair@popple.id.au>
Date: Thu,  6 Mar 2014 14:52:25 +1100

> +	out_be32(dev->reg, in_be32(dev->reg) | WKUP_ETH_RGMIIEN
> +		 | WKUP_ETH_TX_OE | WKUP_ETH_RX_IE);

When an expression spans multiple lines, the lines should end with
operators rather than begin with them.

Also, it would be easier to read this call if parenthesis were put
around the third argument and then indented to match, f.e.:

	out_be32(dev->reg, (in_be32(dev->reg) | WKUP_ETH_RGMIIEN |
			    WKUP_ETH_TX_OE | WKUP_ETH_RX_IE));
