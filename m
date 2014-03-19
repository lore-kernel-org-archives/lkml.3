Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaCSUZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:25:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38687 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaCSUZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:25:04 -0400
Date: Wed, 19 Mar 2014 16:24:59 -0400 (EDT)
Message-Id: <20140319.162459.897793286761249454.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: jesse@nicira.com, pshelar@nicira.com, tgraf@redhat.com,
        dev@openvswitch.org, pablo@netfilter.org, kaber@trash.net,
        kadlec@blackhole.kfki.hu, edumazet@google.com, dborkman@redhat.com,
        therbert@google.com, jasowang@redhat.com, fw@strlen.de,
        joe@perches.com, horms@verge.net.au, jiri@resnulli.us, mst@redhat.com,
        Paul.Durrant@citrix.com, JBeulich@suse.com,
        herbert@gondor.apana.org.au, mszeredi@suse.cz,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] core, nfqueue, openvswitch: Orphan frags in
 skb_zerocopy and handle errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395177455-2077-1-git-send-email-zoltan.kiss@citrix.com>
References: <1395177455-2077-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Mar 2014 13:25:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Tue, 18 Mar 2014 21:17:35 +0000

> skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
> orphan them. Also, it doesn't handle errors, so this patch takes care of that
> as well.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> ---
>  net/openvswitch/datapath.c |    6 ++++++

Something is seriously wrong with the diffstat generated for
your submission, please fix this and resubmit.

Thank you.

