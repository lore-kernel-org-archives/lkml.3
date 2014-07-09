Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbaGIVdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:33:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33904 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaGIVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:33:15 -0400
Date: Wed, 09 Jul 2014 14:33:12 -0700 (PDT)
Message-Id: <20140709.143312.1847154920217915711.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ipconfig: move ic_dev_xid under
 IPCONFIG_BOOTP
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404930921-14879-1-git-send-email-fabf@skynet.be>
References: <1404930921-14879-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 09 Jul 2014 14:33:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed,  9 Jul 2014 20:35:21 +0200

> ic_dev_xid is only used in __init ic_bootp_recv under IPCONFIG_BOOTP
> and __init ic_dynamic under IPCONFIG_DYNAMIC(which is itself defined
> with the same IPCONFIG_BOOTP)
> 
> This patch fixes the following warning when IPCONFIG_BOOTP is not set:
>>> net/ipv4/ipconfig.c:146:15: warning: 'ic_dev_xid' defined but not used [-Wunused-variable]
>     static __be32 ic_dev_xid;  /* Device under configuration */
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thank you.
