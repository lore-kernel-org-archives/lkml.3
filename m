Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3GWClT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:41:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38588 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754927Ab3GWClS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:41:18 -0400
Message-ID: <1374547276.8308.12.camel@joe-AO722>
Subject: Re: [PATCH] hashtable: add hash_for_each_possible_rcu_notrace()
From: Joe Perches <joe@perches.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 19:41:16 -0700
In-Reply-To: <51EDEA39.3000400@ozlabs.ru>
References: <1373084210-27767-1-git-send-email-aik@ozlabs.ru>
	 <51E3C92B.2070704@ozlabs.ru> <51EDEA39.3000400@ozlabs.ru>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 12:28 +1000, Alexey Kardashevskiy wrote:
> Anyone, ping. Is it good, bad, ugly (ack/nack)? Thanks!
> 
> Is there any "trivial patches" list? Could not find it on vger.

Jiri Kosina has trivial@kernel.org

Also, there's kernel-janitors

http://vger.kernel.org/vger-lists.html#kernel-janitors
http://kernelnewbies.org/KernelJanitors

MAINTAINERS has an entry:

TRIVIAL PATCHES
M:	Jiri Kosina <trivial@kernel.org>
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
S:	Maintained
K:	^Subject:.*(?i)trivial



