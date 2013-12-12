Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3LLBBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:01:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60850 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3LLBB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:01:29 -0500
Date: Wed, 11 Dec 2013 20:01:27 -0500 (EST)
Message-Id: <20131211.200127.1712966779087317601.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jasowang@redhat.com,
        wuzhy@linux.vnet.ibm.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131211.195852.780453472852893891.davem@davemloft.net>
References: <20131211.193639.2058525533631918382.davem@davemloft.net>
	<20131212114959.b08ea67fe5624ed6fb392c52@canb.auug.org.au>
	<20131211.195852.780453472852893891.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 17:01:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 11 Dec 2013 19:58:52 -0500 (EST)

> Ok I should probably revert that one too.
> 
> I'll go ahead and do that now, because it's the most straightforward
> way to avoid this merge conflict.

Actually scratch that, there is no dependency between these two changes,
it just causes overlapping changes.

If it were the case that the 'net' bug fix actually added back a use
of that removed variable, things would be different.
