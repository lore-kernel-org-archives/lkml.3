Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbaC0TaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:30:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57198 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbaC0TaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:30:02 -0400
Date: Thu, 27 Mar 2014 15:29:56 -0400 (EDT)
Message-Id: <20140327.152956.1528740039185894234.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: jesse@nicira.com, pshelar@nicira.com, tgraf@redhat.com,
        dev@openvswitch.org, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        edumazet@google.com, dborkman@redhat.com, therbert@google.com,
        jasowang@redhat.com, fw@strlen.de, joe@perches.com, horms@verge.net.au,
        jiri@resnulli.us, mst@redhat.com, Paul.Durrant@citrix.com,
        JBeulich@suse.com, herbert@gondor.apana.org.au, mszeredi@suse.cz,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5] core, nfqueue, openvswitch: Orphan frags in
 skb_zerocopy and handle errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395873465-22282-1-git-send-email-zoltan.kiss@citrix.com>
References: <1395873465-22282-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Mar 2014 12:30:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Wed, 26 Mar 2014 22:37:45 +0000

> skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
> orphan them. Also, it doesn't handle errors, so this patch takes care of that
> as well, and modify the callers accordingly. skb_tx_error() is also added to
> the callers so they will signal the failed delivery towards the creator of the
> skb.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

Fingers crossed :-)  Applied, thanks Zoltan.
