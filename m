Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3GWCn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:43:28 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43166 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab3GWCn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:43:27 -0400
Message-ID: <51EDEDC6.2040007@ozlabs.ru>
Date: Tue, 23 Jul 2013 12:43:18 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hashtable: add hash_for_each_possible_rcu_notrace()
References: <1373084210-27767-1-git-send-email-aik@ozlabs.ru>  <51E3C92B.2070704@ozlabs.ru> <51EDEA39.3000400@ozlabs.ru> <1374547276.8308.12.camel@joe-AO722>
In-Reply-To: <1374547276.8308.12.camel@joe-AO722>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 12:41 PM, Joe Perches wrote:
> On Tue, 2013-07-23 at 12:28 +1000, Alexey Kardashevskiy wrote:
>> Anyone, ping. Is it good, bad, ugly (ack/nack)? Thanks!
>>
>> Is there any "trivial patches" list? Could not find it on vger.
> 
> Jiri Kosina has trivial@kernel.org
> 
> Also, there's kernel-janitors
> 
> http://vger.kernel.org/vger-lists.html#kernel-janitors
> http://kernelnewbies.org/KernelJanitors
> 
> MAINTAINERS has an entry:
> 
> TRIVIAL PATCHES
> M:	Jiri Kosina <trivial@kernel.org>
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
> S:	Maintained
> K:	^Subject:.*(?i)trivial


Cool, thanks! But is that patch really trivial? :)


-- 
Alexey
