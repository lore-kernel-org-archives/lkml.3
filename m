Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaABIiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 03:38:16 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:61649
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbaABIiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 03:38:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,589,1384297200"; 
   d="scan'208";a="43218525"
Date: Thu, 2 Jan 2014 09:38:12 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Ding Tianhong <dingtianhong@huawei.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND net-next 1/7] bonding: use ether_addr_equal_unaligned
 for bond addr compare
In-Reply-To: <52C52180.2030707@huawei.com>
Message-ID: <alpine.DEB.2.02.1401020937490.2182@localhost6.localdomain6>
References: <52C4BD16.5010702@huawei.com> <alpine.DEB.2.02.1401020839000.2182@localhost6.localdomain6> <52C52180.2030707@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1867944953-1388651893=:2182"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1867944953-1388651893=:2182
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 2 Jan 2014, Ding Tianhong wrote:

> On 2014/1/2 15:39, Julia Lawall wrote:
> > Are the casts needed
> 
> 
> Yes, otherwise the warming will report:
> 
> /net-next/drivers/net/bonding/bond_3ad.c:427: warning: passing argument 1 of ‘ether_addr_equal_64bits’ from incompatible pointer type

Is it necessary for this driver to use a different type from everyone 
else?

julia
--8323328-1867944953-1388651893=:2182--
