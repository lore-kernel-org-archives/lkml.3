Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaGIDvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:51:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56246 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaGIDvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:51:19 -0400
Date: Tue, 08 Jul 2014 20:51:18 -0700 (PDT)
Message-Id: <20140708.205118.498700090425113718.davem@davemloft.net>
To: decot@googlers.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, edumazet@google.com, amwang@redhat.com,
        antonio@meshcoding.com, jpirko@redhat.com
Subject: Re: [PATCH net-next v2] netpoll: fix use after free
From: David Miller <davem@davemloft.net>
In-Reply-To: <96b940137a50e5c387687bb4f57de8b0435a653f.1404857349.git.decot@googlers.com>
References: <cover.1404857349.git.decot@googlers.com>
	<96b940137a50e5c387687bb4f57de8b0435a653f.1404857349.git.decot@googlers.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 20:51:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>
Date: Tue,  8 Jul 2014 15:14:41 -0700

> After a bonding master reclaims the netpoll info struct, slaves could
> still hold a pointer to the reclaimed data. This patch fixes it: as
> soon as netpoll_async_cleanup is called for a slave (eg. when
> un-enslaved), we make sure that this slave doesn't point to the data.
> 
> Signed-off-by: David Decotigny <decot@googlers.com>

Applied, thank you.
