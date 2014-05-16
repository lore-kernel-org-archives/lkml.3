Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992490AbaEPTZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:25:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48518 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992457AbaEPTZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:25:22 -0400
Date: Fri, 16 May 2014 15:25:20 -0400 (EDT)
Message-Id: <20140516.152520.1325547885798958983.davem@davemloft.net>
To: dhowells@redhat.com
Cc: netdev@vger.kernel.org, nwf@cs.jhu.edu, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_rxrpc: Fix XDR length check in rxrpc key
 demarshalling.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140515145122.29177.65285.stgit@warthog.procyon.org.uk>
References: <20140515145122.29177.65285.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 May 2014 12:25:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 15 May 2014 15:51:22 +0100

> From: Nathaniel W Filardo <nwf@cs.jhu.edu>
> 
> There may be padding on the ticket contained in the key payload, so just ensure
> that the claimed token length is large enough, rather than exactly the right
> size.
> 
> Signed-off-by: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied, thanks.
