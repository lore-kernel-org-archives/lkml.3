Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3EaA4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:56:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59714 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3EaAzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:55:53 -0400
Date: Thu, 30 May 2013 17:55:49 -0700 (PDT)
Message-Id: <20130530.175549.407800685811475192.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: buytenh@wantstofly.org, jason@lakedaemon.net, andrew@lunn.ch,
        benh@kernel.crashing.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/13] net: mv643xx_eth DT support and fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369855975-21489-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1369855975-21489-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Wed, 29 May 2013 21:32:42 +0200

> For the patches above I suggest to take Patches 1-6 through David
> Miller's branch, and Patches 7-12 through Jason Cooper's when the
> former have appeared on mainline linux. The patch set has been based
> on v3.10-rc3.

Patches 1-6 applied to net-next, and patch #1 queued up for -stable.

Thanks!
