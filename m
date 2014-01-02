Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaABJOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 04:14:38 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:15517
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbaABJOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:14:36 -0500
X-IronPort-AV: E=Sophos;i="4.95,589,1384297200"; 
   d="scan'208";a="43221970"
Date: Thu, 2 Jan 2014 10:14:33 +0100 (CET)
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
In-Reply-To: <52C52AAD.8040603@huawei.com>
Message-ID: <alpine.DEB.2.02.1401021011400.2182@localhost6.localdomain6>
References: <52C4BD16.5010702@huawei.com> <alpine.DEB.2.02.1401020839000.2182@localhost6.localdomain6> <52C52180.2030707@huawei.com> <alpine.DEB.2.02.1401020937490.2182@localhost6.localdomain6> <52C52AAD.8040603@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1198458177-1388654075=:2182"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1198458177-1388654075=:2182
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 2 Jan 2014, Ding Tianhong wrote:

> On 2014/1/2 16:38, Julia Lawall wrote:
> > On Thu, 2 Jan 2014, Ding Tianhong wrote:
> > 
> >> On 2014/1/2 15:39, Julia Lawall wrote:
> >>> Are the casts needed
> >>
> >>
> >> Yes, otherwise the warming will report:
> >>
> >> /net-next/drivers/net/bonding/bond_3ad.c:427: warning: passing argument 1 of ‘ether_addr_equal_64bits’ from incompatible pointer type
> > 
> > Is it necessary for this driver to use a different type from everyone 
> > else?
> > 
> > julia
> > 
> Did you mean the MAC_ADDRESS_EQUAL is excess?
> I did not remove it because the codes no need to be changed more and it looks that didn't take any negative effect.

No, I was wondering about the mac_addr type, defined in bond_3ad.h.  Other 
code just has the array inlined into the containing structure.

julia
--8323328-1198458177-1388654075=:2182--
