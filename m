Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081Ab3EBSGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:06:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58924 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab3EBSGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:06:51 -0400
Date: Thu, 02 May 2013 14:06:48 -0400 (EDT)
Message-Id: <20130502.140648.1138582574178897490.davem@davemloft.net>
To: mirqus@gmail.com
Cc: dcbw@redhat.com, torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130502.135542.1332946768988319212.davem@davemloft.net>
References: <20130502.133947.387694205526879673.davem@davemloft.net>
	<CAHXqBF+Xb0ZVo2tO-0m59JJDrwy5vYX6=jLbts_ZAv5Pk+7SCw@mail.gmail.com>
	<20130502.135542.1332946768988319212.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 May 2013 11:06:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 02 May 2013 13:55:42 -0400 (EDT)

> From: Micha©© Miros©©aw <mirqus@gmail.com>
> Date: Thu, 2 May 2013 19:47:25 +0200
> 
>> Are you sure it's "flags"? /sys/class/net/*/features were removed some
>> time ago, and flags don't depend on NETIF_F_*.
> 
> Oh, it's flags, which is printed in raw hex by net/core/net-sysfs.c:
> 
> NETDEVICE_SHOW(flags, fmt_hex);

Oh you're right, I'm confusing netdev->flags with netdev->features, my bad.

More coffee needed :)
