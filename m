Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab3BKFXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 00:23:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33835 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3BKFXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 00:23:07 -0500
Date: Mon, 11 Feb 2013 00:23:05 -0500 (EST)
Message-Id: <20130211.002305.116088533226868074.davem@davemloft.net>
To: yoshfuji@linux-ipv6.org
Cc: fengguang.wu@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net neighbour,decnet: Ensure to align device
 private data on preferred alignment.
From: David Miller <davem@davemloft.net>
In-Reply-To: <511680CB.9010502@linux-ipv6.org>
References: <511680CB.9010502@linux-ipv6.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Date: Sun, 10 Feb 2013 02:00:59 +0900

> To allow both of protocol-specific data and device-specific data
> attached with neighbour entry, and to eliminate size calculation
> cost when allocating entry, sizeof protocol-speicic data must be
> multiple of NEIGH_PRIV_ALIGN.  On 64bit archs,
> sizeof(struct dn_neigh) is multiple of NEIGH_PRIV_ALIGN, but on
> 32bit archs, it was not.
> 
> Introduce NEIGH_ENTRY_SPACE() macro to ensure that protocol-specific
> entry-size meets our requirement.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

Applied.
