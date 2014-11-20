Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbaKTRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:16:57 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:47421 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559AbaKTRQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:16:56 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2014 12:16:55 EST
Message-ID: <546E204B.5080106@mellanox.com>
Date: Thu, 20 Nov 2014 19:09:31 +0200
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, Eli Cohen <eli@mellanox.com>
CC: <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: mlx5: don't duplicate kvfree()
References: <20141120081357.GI7996@ZenIV.linux.org.uk> <20141120081726.GK7996@ZenIV.linux.org.uk>
In-Reply-To: <20141120081726.GK7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.223.3.34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 10:17 AM, Al Viro wrote:
> On Thu, Nov 20, 2014 at 08:13:57AM +0000, Al Viro wrote:
>> >  9 files changed, 21 insertions(+), 35 deletions(-)
> grr... 8 files changed, actually - that was from the diff that included mlx4
> bits.  Patch split correctly and sent in two pieces, summary left as is ;-/
> Sorry about the confusion it might cause...
Al,

I think the best way to proceed here is to come up with mlx4 and mlx5 
patches and get both of them in through netdev / net-nexttree, don't 
worry about each of these drivers have a part which is also under 
drivers/infiniband/hw -- it doesn't justify splitting in this case

Or.
