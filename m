Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaGaVHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:07:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51002 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaGaVHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:07:51 -0400
Date: Thu, 31 Jul 2014 14:07:50 -0700 (PDT)
Message-Id: <20140731.140750.2142330641462047009.davem@davemloft.net>
To: dbanerje@akamai.com
Cc: sergei.shtylyov@cogentembedded.com, netdev@vger.kernel.org, ja@ssi.bg,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tcp: don't require root to read tcp_metrics
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406742617-10556-1-git-send-email-dbanerje@akamai.com>
References: <53D92D92.4090403@cogentembedded.com>
	<1406742617-10556-1-git-send-email-dbanerje@akamai.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Jul 2014 14:07:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Debabrata Banerjee <dbanerje@akamai.com>
Date: Wed, 30 Jul 2014 13:50:17 -0400

> commit d23ff7016 (tcp: add generic netlink support for tcp_metrics) introduced
> netlink support for the new tcp_metrics, however it restricted getting of
> tcp_metrics to root user only. This is a change from how these values could
> have been fetched when in the old route cache. Unless there's a legitimate
> reason to restrict the reading of these values it would be better if normal
> users could fetch them.
> 
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: linux-kernel@vger.kernel.org
> 
> Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>

Applied to net-next, thanks.
