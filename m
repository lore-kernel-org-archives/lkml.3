Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaHFUxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:53:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43622 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaHFUxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:53:11 -0400
Date: Wed, 06 Aug 2014 13:53:10 -0700 (PDT)
Message-Id: <20140806.135310.1924341636144726761.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: steffen.klassert@secunet.com, minipli@googlemail.com, dborkman@redhat.com,
        tgraf@suug.ch, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next 0/4 v5] pktgen: Upstreaming features useful
 for xen-netback/front testing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407349024-2489-1-git-send-email-zoltan.kiss@citrix.com>
References: <1407349024-2489-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Aug 2014 13:53:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Wed, 6 Aug 2014 19:17:00 +0100

> This series is my work during stressing the xen network drivers, hopefully
> others can benefit from it.
> 1/4: Filling payload with pattern, useful for checking data correctness when the
> packets travelling without checksum (~ intrahost VM-to-VM). Already sent it
> separately few times, so its version number differs
> 2/4: fine-grained buffer geometrics
> 3/4: fix UDP checksuming
> 4/4: sending TCP GSO packets. This is an RFC yet, as I'm not certain about all
> things changed here
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

Zoltan, please resubmit this after the merge window closes and I re-open
the net-next tree.

Thank you.
