Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaI2TAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:00:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43736 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbaI2TAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:00:19 -0400
Message-ID: <1412017217.30721.38.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: 3.17-rc1 oops during network interface configuration
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML Kernel <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Saeed Mahameed <saeedm@mellanox.com>, Tal Alon <talal@mellanox.com>,
        Yevgeny Petrilin <yevgenyp@mellanox.com>,
        Roland Dreier <roland@kernel.org>
Date: Mon, 29 Sep 2014 12:00:17 -0700
In-Reply-To: <6C43129E-4365-4BEF-ADAD-963B8F386789@oracle.com>
References: <53F1EF18.7010909@acm.org> <53F47917.8080003@mellanox.com>
	 <F580F466-28A5-4BDD-A338-D5C065A760C1@oracle.com>
	 <541000F1.5000805@mellanox.com>
	 <6C43129E-4365-4BEF-ADAD-963B8F386789@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 14:52 -0400, Chuck Lever wrote:

> Is there a bugzilla report filed for this issue? Has there been any progress
> towards a fix?

This is fixed in Linus tree.

http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=257117862634d89de33fec74858b1a0ba5ab444b

http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=b49fe36208b45f76dfbcfcd3afd952a33fa9f5ce


