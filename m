Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbaKTSvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:51:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59453 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaKTSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:51:11 -0500
Date: Thu, 20 Nov 2014 18:51:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Eli Cohen <eli@mellanox.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: mlx5: don't duplicate kvfree()
Message-ID: <20141120185108.GP7996@ZenIV.linux.org.uk>
References: <20141120081357.GI7996@ZenIV.linux.org.uk>
 <20141120081726.GK7996@ZenIV.linux.org.uk>
 <546E204B.5080106@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546E204B.5080106@mellanox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 07:09:31PM +0200, Or Gerlitz wrote:
> On 11/20/2014 10:17 AM, Al Viro wrote:
> >On Thu, Nov 20, 2014 at 08:13:57AM +0000, Al Viro wrote:
> >>>  9 files changed, 21 insertions(+), 35 deletions(-)
> >grr... 8 files changed, actually - that was from the diff that included mlx4
> >bits.  Patch split correctly and sent in two pieces, summary left as is ;-/
> >Sorry about the confusion it might cause...
> Al,
> 
> I think the best way to proceed here is to come up with mlx4 and
> mlx5 patches and get both of them in through netdev / net-nexttree,
> don't worry about each of these drivers have a part which is also
> under drivers/infiniband/hw -- it doesn't justify splitting in this
> case

Both had been sent to netdev today (and ACKed by respective drivers'
maintainers).  I'd certainly prefer not to put them through vfs.git,
but beyond that I really don't care which tree do those go into...
