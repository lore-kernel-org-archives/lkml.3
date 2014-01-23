Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaAWF7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 00:59:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54154 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaAWF7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 00:59:45 -0500
Date: Wed, 22 Jan 2014 21:59:44 -0800 (PST)
Message-Id: <20140122.215944.1857286066071533638.davem@davemloft.net>
To: ydroneaud@opteya.com
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jukka.rissanen@linux.intel.com,
        alex.aring@gmail.com
Subject: Re: [PATCH] 6lowpan: add a license to 6lowpan_iphc module
From: David Miller <davem@davemloft.net>
In-Reply-To: <1390418724-9804-1-git-send-email-ydroneaud@opteya.com>
References: <1390418724-9804-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Droneaud <ydroneaud@opteya.com>
Date: Wed, 22 Jan 2014 20:25:24 +0100

> Since commit 8df8c56a5abc, 6lowpan_iphc is a module of its own.
> 
> Unfortunately, it lacks some infrastructure to behave like a
> good kernel citizen:
> 
>   kernel: 6lowpan_iphc: module license 'unspecified' taints kernel.
>   kernel: Disabling lock debugging due to kernel taint
> 
> This patch adds the basic MODULE_LICENSE(); with GPL license:
> the code was copied from net/ieee802154/6lowpan.c which is GPL
> and the module exports symbol with EXPORT_SYMBOL_GPL();.
> 
> Cc: Jukka Rissanen <jukka.rissanen@linux.intel.com>
> Cc: Alexander Aring <alex.aring@gmail.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>

Applied.
