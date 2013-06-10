Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3FJSwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:52:07 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:49550 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3FJSwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:52:05 -0400
Message-ID: <1370890317.3252.10.camel@edumazet-glaptop>
Subject: Re: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu
 macro
From: Eric Dumazet <eric.dumazet@gmail.com>
To: zhmurov@yandex-team.ru
Cc: David Miller <davem@davemloft.net>, paulmck@linux.vnet.ibm.com,
        klamm@yandex-team.ru, brouer@redhat.com, dipankar@in.ibm.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, David.Laight@ACULAB.COM, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Date: Mon, 10 Jun 2013 11:51:57 -0700
In-Reply-To: <51B61B22.2010604@yandex-team.ru>
References: <1370229169.24311.119.camel@edumazet-glaptop>
	 <20130602.202703.1059637861388689182.davem@davemloft.net>
	 <20130603034254.GC29614@linux.vnet.ibm.com>
	 <20130602.204915.334823676645400072.davem@davemloft.net>
	 <51B61B22.2010604@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 22:29 +0400, Boris B. Zhmurov wrote:

> Hello David,
> 
> Do you think, this patch is "stable material" and should be included in
> 3.0-stable and 3.4-stable trees? Thanks.

Yes, its in the stable queue :

http://patchwork.ozlabs.org/bundle/davem/stable/?state=*



