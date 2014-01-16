Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaAPF54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 00:57:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45152 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaAPF5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 00:57:54 -0500
Date: Wed, 15 Jan 2014 21:57:53 -0800 (PST)
Message-Id: <20140115.215753.1619877365795484712.davem@davemloft.net>
To: ethan.zhao@oracle.com
Cc: aaron.f.brown@intel.com, jeffrey.t.kirsher@intel.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethan.kernel@gmail.com
Subject: Re: [PATCH 1/2 Net-next] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT
 macro and cleanup const 63
From: David Miller <davem@davemloft.net>
In-Reply-To: <52D75F1D.9040405@oracle.com>
References: <52D75F1D.9040405@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ethan zhao <ethan.zhao@oracle.com>
Date: Thu, 16 Jan 2014 12:25:01 +0800

> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>

Please don't give two signoffs for yourself, it is not appropriate at
all.

I am very genuinely curious where you got the idea to do that,
particularly as I've never seen anyone else do it before.  So it's
really not possible that you got the idea from someone else's actions.
