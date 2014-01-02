Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750858AbaABHjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 02:39:35 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57669 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbaABHjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 02:39:33 -0500
X-IronPort-AV: E=Sophos;i="4.95,589,1384297200"; 
   d="scan'208";a="51358531"
Date: Thu, 2 Jan 2014 08:39:29 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Ding Tianhong <dingtianhong@huawei.com>
cc: Joe Perches <joe@perches.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Julia Lawall <julia.lawall@lip6.fr>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND net-next 1/7] bonding: use ether_addr_equal_unaligned
 for bond addr compare
In-Reply-To: <52C4BD16.5010702@huawei.com>
Message-ID: <alpine.DEB.2.02.1401020839000.2182@localhost6.localdomain6>
References: <52C4BD16.5010702@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -// compare MAC addresses
> -#define MAC_ADDRESS_COMPARE(A, B) memcmp(A, B, ETH_ALEN)
> +/* compare MAC addresses */
> +#define MAC_ADDRESS_EQUAL(A, B)	\
> +	ether_addr_equal_64bits((const u8 *)A, (const u8 *)B)

Are the casts needed?

julia
