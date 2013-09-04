Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934286Ab3IDC2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:28:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53893 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934187Ab3IDC2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:28:20 -0400
Date: Tue, 03 Sep 2013 22:28:18 -0400 (EDT)
Message-Id: <20130903.222818.797621801374088373.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com
Subject: Re: [PATCH net-next] drivers/net: Convert uses of
 compare_ether_addr to ether_addr_equal
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378061483.1953.3.camel@joe-AO722>
References: <1378061483.1953.3.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 03 Sep 2013 19:28:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 01 Sep 2013 11:51:23 -0700

> Use the new bool function ether_addr_equal to add
> some clarity and reduce the likelihood for misuse
> of compare_ether_addr for sorting.
> 
> Done via cocci script: (and a little typing)
 ...
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
