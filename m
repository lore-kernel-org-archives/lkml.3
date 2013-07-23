Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3GWHxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:53:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:47091 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab3GWHw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:52:58 -0400
Message-ID: <1374565947.3916.74.camel@pasglop>
Subject: Re: [PATCH] hashtable: add hash_for_each_possible_rcu_notrace()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joe Perches <joe@perches.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 17:52:27 +1000
In-Reply-To: <1374548005.8308.15.camel@joe-AO722>
References: <1373084210-27767-1-git-send-email-aik@ozlabs.ru>
	 <51E3C92B.2070704@ozlabs.ru> <51EDEA39.3000400@ozlabs.ru>
	 <1374547276.8308.12.camel@joe-AO722> <51EDEDC6.2040007@ozlabs.ru>
	 <1374548005.8308.15.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 19:53 -0700, Joe Perches wrote:
> Anyway, you cc'd all the right people already.
> 
> If no one responds after a couple weeks, either
> send it to Jiri or directly to Linus.

Or I'll just merge it with the rest of the series.

Cheers,
Ben.


