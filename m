Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3GQGDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 02:03:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44728 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3GQGDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 02:03:14 -0400
Date: Tue, 16 Jul 2013 23:03:01 -0700 (PDT)
Message-Id: <20130716.230301.2028486316145884715.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net] hyperv: Fix the NETIF_F_SG flag setting in netvsc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374040880-20468-1-git-send-email-haiyangz@microsoft.com>
References: <1374040880-20468-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 16 Jul 2013 23:03:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 16 Jul 2013 23:01:20 -0700

> SG mode is not currently supported by netvsc, so remove this flag for now.
> Otherwise, it will be unconditionally enabled by commit ec5f0615642
>     "Kill link between CSUM and SG features"
> Previously, the SG feature is disabled because CSUM is not set here.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied and queued up for -stable, thanks.
