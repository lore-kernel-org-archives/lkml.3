Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3HBVuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:50:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42153 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab3HBVup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:50:45 -0400
Date: Fri, 02 Aug 2013 14:50:41 -0700 (PDT)
Message-Id: <20130802.145041.845804796107623114.davem@davemloft.net>
To: amwang@redhat.com
Cc: netdev@vger.kernel.org, dborkman@redhat.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch net-next v2 1/8] net: introduce generic union inet_addr
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375427674-21735-2-git-send-email-amwang@redhat.com>
References: <1375427674-21735-1-git-send-email-amwang@redhat.com>
	<1375427674-21735-2-git-send-email-amwang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 02 Aug 2013 14:50:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Fri,  2 Aug 2013 15:14:27 +0800

> From: Cong Wang <amwang@redhat.com>
> 
> Introduce a generic IP address type, union inet_addr, so that
> subsystems don't have to use their own definitions. Because
> netpoll already defines union inet_addr, just move it to global.
> Some of the helper functions will be used by VXLAN IPv6 code too.
> 
> This patch also reuses the "%pIS" specifier, to make it accept
> union inet_addr instead of struct sockaddr.
> 
> Cc: Daniel Borkmann <dborkman@redhat.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Cong Wang <amwang@redhat.com>

Changing %pIS to %pIA is pure churn, and of zero value that I can see.

Every time I review this patch set I discover some new thing that I'm
very disappointed with.

You're going to have to stop being so ambitious, and start very small.

Maybe one tiny patch at a time if needed.
