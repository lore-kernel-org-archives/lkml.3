Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758Ab3DHQQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:16:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49331 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934422Ab3DHQQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:16:21 -0400
Date: Mon, 08 Apr 2013 12:16:20 -0400 (EDT)
Message-Id: <20130408.121620.1034249208373430154.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net,2/2] hyperv: Fix RNDIS send_completion code path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365198280-23270-2-git-send-email-haiyangz@microsoft.com>
References: <1365198280-23270-1-git-send-email-haiyangz@microsoft.com>
	<1365198280-23270-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 08 Apr 2013 09:16:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri,  5 Apr 2013 14:44:40 -0700

> In some cases, the VM_PKT_COMP message can arrive later than RNDIS completion
> message, which will free the packet memory. This may cause panic due to access
> to freed memory in netvsc_send_completion().
> 
> This patch fixes this problem by removing rndis_filter_send_request_completion()
> from the code path. The function was a no-op.
> 
> Reported-by: Long Li <longli@microsoft.com>
> Tested-by: Long Li <longli@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
