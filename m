Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3GWCx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:53:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54423 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751135Ab3GWCx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:53:26 -0400
Message-ID: <1374548005.8308.15.camel@joe-AO722>
Subject: Re: [PATCH] hashtable: add hash_for_each_possible_rcu_notrace()
From: Joe Perches <joe@perches.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 19:53:25 -0700
In-Reply-To: <51EDEDC6.2040007@ozlabs.ru>
References: <1373084210-27767-1-git-send-email-aik@ozlabs.ru>
	 <51E3C92B.2070704@ozlabs.ru> <51EDEA39.3000400@ozlabs.ru>
	 <1374547276.8308.12.camel@joe-AO722> <51EDEDC6.2040007@ozlabs.ru>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 12:43 +1000, Alexey Kardashevskiy wrote:
> On 07/23/2013 12:41 PM, Joe Perches wrote:
> > On Tue, 2013-07-23 at 12:28 +1000, Alexey Kardashevskiy wrote:
> >> Anyone, ping. Is it good, bad, ugly (ack/nack)? Thanks!
> >> Is there any "trivial patches" list? Could not find it on vger.
[]
> > MAINTAINERS has an entry:
> > TRIVIAL PATCHES
> > M:	Jiri Kosina <trivial@kernel.org>
> > T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
[]
> Cool, thanks! But is that patch really trivial? :)

:)  Was that the question?

Anyway, you cc'd all the right people already.

If no one responds after a couple weeks, either
send it to Jiri or directly to Linus.


