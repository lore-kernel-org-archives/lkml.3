Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbaGATO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:14:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34687 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaGATOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:14:55 -0400
Date: Tue, 01 Jul 2014 12:14:53 -0700 (PDT)
Message-Id: <20140701.121453.646524500364143878.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: steffen.klassert@secunet.com, minipli@googlemail.com, dborkman@redhat.com,
        tgraf@suug.ch, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next] pktgen: Allow setting frag sizes individually
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403728972-29548-3-git-send-email-zoltan.kiss@citrix.com>
References: <1403728972-29548-1-git-send-email-zoltan.kiss@citrix.com>
	<1403728972-29548-3-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Jul 2014 12:14:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Wed, 25 Jun 2014 21:42:51 +0100

> By defining the number of frags via "nfrags", their sizes get calculated by
> pktgen. This patch allows their offsets and sizes to be specified via
> "frag_off-len", in a comma separated list (e.g.
> "frag_off-len 0-1,500-200,5000-10,9-100). The first is the offset
> (0 <= offset < 2^16), second is size (0 < length <= 65536). This also determines
> the number of frags, so it overwrites "frags" (and vice versa, "frags"
> invalidate this setting)
> xen-netback is prone to have problem with compound pages, as the memory granting
> interface can only handle 4k pages. This extension of pktgen is proven to be
> useful to test that.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

Can you respin these against current net-next and repost, thanks Zoltan.
