Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3IBJTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:19:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab3IBJTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:19:05 -0400
Message-ID: <1378113535.2853.0.camel@cr0>
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: Cong Wang <amwang@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Sep 2013 17:18:55 +0800
In-Reply-To: <20130902191120.645dab701e2a68bb2ac6ba33@canb.auug.org.au>
References: <20130902191120.645dab701e2a68bb2ac6ba33@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 19:11 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/vxlan.c: In function 'vxlan6_xmit_skb':
> drivers/net/vxlan.c:1441:3: error: implicit declaration of function 'csum_ipv6_magic' [-Werror=implicit-function-declaration]
>    uh->check = csum_ipv6_magic(saddr, daddr, skb->len,
>    ^
> 
> Caused by commit e4c7ed415387 ("vxlan: add ipv6 support").
> 
> Please read Rule 1 in Documentation/SubmitChecklist.
> 
> I added the following patch for today:

Hi, Stephen

I sent a same patch this morning:
http://marc.info/?l=linux-netdev&m=137808763132336&w=2

Thanks!

