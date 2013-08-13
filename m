Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab3HMXba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:31:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45401 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3HMXb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:31:29 -0400
Date: Tue, 13 Aug 2013 16:31:27 -0700 (PDT)
Message-Id: <20130813.163127.1435008671852578392.davem@davemloft.net>
To: vyasevic@redhat.com
Cc: ast@fiberby.net, stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtnetlink: rtnl_bridge_getlink: Call nlmsg_find_attr()
 with ifinfomsg header
From: David Miller <davem@davemloft.net>
In-Reply-To: <520ABBFD.7080004@redhat.com>
References: <52093E29.5010604@redhat.com>
	<20130813.155443.1789890841731289313.davem@davemloft.net>
	<520ABBFD.7080004@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 13 Aug 2013 16:31:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevic@redhat.com>
Date: Tue, 13 Aug 2013 19:06:37 -0400

> ast explained it in his header message (Bridge VLAN kernel/iproute2
> incompatibility)

That's not a header message.

Header messages have a subject prefix of the form "[PATCH 0/N]".
If he had done this I wouldn't have had to ask such silly
questions.
