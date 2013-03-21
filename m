Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934457Ab3CUQhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:37:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44134 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934359Ab3CUQhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:37:14 -0400
Date: Thu, 21 Mar 2013 12:37:13 -0400 (EDT)
Message-Id: <20130321.123713.2259863785549784643.davem@davemloft.net>
To: avagin@openvz.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xemul@parallels.com,
        edumazet@google.com, paulmck@linux.vnet.ibm.com, dhowells@redhat.com
Subject: Re: [PATCH 1/3] net: fix *_DIAG_MAX constants
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363883628-7249-2-git-send-email-avagin@openvz.org>
References: <1363883628-7249-1-git-send-email-avagin@openvz.org>
	<1363883628-7249-2-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 21 Mar 2013 09:37:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Thu, 21 Mar 2013 20:33:46 +0400

> Follow the common pattern and define *_DIAG_MAX like:
> 
>         [...]
>         __XXX_DIAG_MAX,
> };
> 
> Because everyone is used to do:
> 
>         struct nlattr *attrs[XXX_DIAG_MAX+1];
> 
>         nla_parse([...], XXX_DIAG_MAX, [...]
> 
> Reported-by: Thomas Graf <tgraf@suug.ch>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Applied to 'net' and queued up for -stable.

Thanks.
