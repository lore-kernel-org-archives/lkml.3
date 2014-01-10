Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbaAJSYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:24:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41554 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaAJSY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:24:28 -0500
Date: Fri, 10 Jan 2014 13:24:20 -0500 (EST)
Message-Id: <20140110.132420.1024215975653490661.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net V3 1/2] macvlan: forbid L2 fowarding offload for
 macvtap
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389341906-2367-1-git-send-email-jasowang@redhat.com>
References: <1389341906-2367-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 10 Jan 2014 16:18:25 +0800

> L2 fowarding offload will bypass the rx handler of real device. This will make
> the packet could not be forwarded to macvtap device. Another problem is the
> dev_hard_start_xmit() called for macvtap does not have any synchronization.
> 
> Fix this by forbidding L2 forwarding for macvtap.
> 
> Cc: John Fastabend <john.r.fastabend@intel.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied.
