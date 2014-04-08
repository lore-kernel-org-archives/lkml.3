Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbaDHQhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:37:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43422 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbaDHQhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:37:52 -0400
Date: Tue, 08 Apr 2014 12:37:50 -0400 (EDT)
Message-Id: <20140408.123750.693837509861075227.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sasha.levin@oracle.com, netdev@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        davej@redhat.com
Subject: Re: [PATCH] decnet: fix possible NULL deref in dnet_select_source()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396932704.16584.9.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1396821554.12330.51.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140407.151854.411047851818388937.davem@davemloft.net>
	<1396932704.16584.9.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 07 Apr 2014 21:51:44 -0700

> On Mon, 2014-04-07 at 15:18 -0400, David Miller wrote:
> 
>> And in the loopback case, it is the decnet stack's responsibility to
>> make sure ->dn_ptr is setup properly, else it should fail the module
>> load and stack initialization.
>> can fix this properly.
> 
> This was based on Sasha report and my limited time.
> It seems you have more time than me to spend on decnet !

Understood, I'll take a deeper look into this.
