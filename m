Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaEBVoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:44:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37586 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaEBVn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:43:58 -0400
Date: Fri, 02 May 2014 17:43:42 -0400 (EDT)
Message-Id: <20140502.174342.2106503693159618241.davem@davemloft.net>
To: stgraber@ubuntu.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        ebiederm@xmission.com, jhs@mojatatu.com
Subject: Re: [PATCH] net: Allow tc changes in user namespaces
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398871543-8435-1-git-send-email-stgraber@ubuntu.com>
References: <1398871543-8435-1-git-send-email-stgraber@ubuntu.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 May 2014 14:43:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stéphane Graber <stgraber@ubuntu.com>
Date: Wed, 30 Apr 2014 11:25:43 -0400

> This switches a few remaining capable(CAP_NET_ADMIN) to ns_capable so
> that root in a user namespace may set tc rules inside that namespace.
> 
> Signed-off-by: Stéphane Graber <stgraber@ubuntu.com>
> Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

Applied to net-next, thanks.
