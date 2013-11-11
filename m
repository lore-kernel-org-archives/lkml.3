Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3KKTEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:04:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56861 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab3KKTEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:04:15 -0500
Date: Mon, 11 Nov 2013 14:04:13 -0500 (EST)
Message-Id: <20131111.140413.1835946304303785565.davem@davemloft.net>
To: baker.kernel@gmail.com
Cc: herbert@gondor.hengli.com.au, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next] xfrm: Add check to prevent un-complete key
 manager
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384151951-13549-1-git-send-email-baker.kernel@gmail.com>
References: <1384093556-8987-1-git-send-email-baker.kernel@gmail.com>
	<1384151951-13549-1-git-send-email-baker.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 11 Nov 2013 11:04:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: baker.kernel@gmail.com
Date: Mon, 11 Nov 2013 14:39:11 +0800

> +	if (km->acquire == NULL || km->compile_policy == NULL)
> +		return -EINVAL;

There are 7 function pointer methods that must be fully implemented
in an xfrm_mgr object, not just two.

And really we absolutely do not care at all about your out-of-tree
product, it has no bearing upon what should happen here.
