Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab3HSTox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:44:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59025 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3HSTow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:44:52 -0400
Date: Mon, 19 Aug 2013 12:50:26 -0700 (PDT)
Message-Id: <20130819.125026.636442915180863272.davem@davemloft.net>
To: casey@schaufler-ca.com
Cc: amwang@redhat.com, netdev@vger.kernel.org, james.l.morris@oracle.com,
        sds@tycho.nsa.gov, eparis@parisplace.org, pmoore@redhat.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [Patch net-next v3 9/9] selinux: use generic union inet_addr
From: David Miller <davem@davemloft.net>
In-Reply-To: <52127336.3080209@schaufler-ca.com>
References: <1376907278-26377-1-git-send-email-amwang@redhat.com>
	<1376907278-26377-10-git-send-email-amwang@redhat.com>
	<52127336.3080209@schaufler-ca.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 19 Aug 2013 12:44:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's so that you can pass a generic ipv4/ipv6 address blob into
things like printf formatting, and since there is an address family
member present, it knows what's in there and therefore one printf
format specifier can handle both ipv4 and ipv6 addresses.

Like you, I think these changes a complete waste of time too, I'm just
relaying what I was told.
