Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3KFUYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:24:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43534 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3KFUYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:24:46 -0500
Date: Wed, 06 Nov 2013 15:24:43 -0500 (EST)
Message-Id: <20131106.152443.1288760715552220036.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: dborkman@redhat.com, avagin@openvz.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@plumgrid.com, edumazet@google.com
Subject: Re: [PATCH] net: don't forget to free sk_filter
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383766098.21999.2.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1383753106-26978-1-git-send-email-avagin@openvz.org>
	<527A9638.4020404@redhat.com>
	<1383766098.21999.2.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 06 Nov 2013 12:24:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 06 Nov 2013 11:28:18 -0800

> On Wed, 2013-11-06 at 20:19 +0100, Daniel Borkmann wrote:
> 
>> When you send v2 with Alexei's feedback, please also be more specific
>> in your subject like "net: x86: bpf: don't forget to free sk_filter"
>> or the like. Also it's enough to say 'This memory leak was introduced
>> by commit d45ed4a4e3 ("net: fix unsafe set_memory_rw from softirq")'
>> instead of copying the whole log. Anyways, for v2 with feedback included
>> then:
> 
> Actually, the new way [1] of doing this would be to use the 'Fixes:' tag
> as in :
> 
> Fixes: <12 digits SHA1> ("net: fix unsafe set_memory_rw from softirq")
> 
> [1] As discussed at last Kernel Summit
> 
> Example in 
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6920a1bd037374a632d585de127b6f945199dcb8

Indeed, and I'm totally fine with this new mechanism too, please use it.
