Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab3EGJNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:13:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43792 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198Ab3EGJNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:13:37 -0400
Date: Tue, 07 May 2013 05:13:31 -0400 (EDT)
Message-Id: <20130507.051331.942846520697886744.davem@davemloft.net>
To: khlebnikov@openvz.org
Cc: brouer@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
        fw@strlen.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: frag, fix race conditions in LRU list maintenance
From: David Miller <davem@davemloft.net>
In-Reply-To: <51888F93.3030300@openvz.org>
References: <20130506093318.679f5557@redhat.com>
	<20130506.110800.1388239604905052651.davem@davemloft.net>
	<51888F93.3030300@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 07 May 2013 02:13:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Tue, 07 May 2013 09:22:27 +0400

> Seems like this bug allows to crash kernel remotely.
> Should I send it to stable@ for including into 3.9.y or
> you already have a bunch of patches for it?

I already queued it up for -stable.
