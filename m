Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab3CFWJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:09:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60478 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3CFWJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:09:39 -0500
Date: Wed, 06 Mar 2013 17:09:37 -0500 (EST)
Message-Id: <20130306.170937.1089663491363176160.davem@davemloft.net>
To: bhavesh@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com, sbhatewara@vmware.com
Subject: Re: [PATCH net-next] vmxnet3: prevent div-by-zero panic when ring
 resizing uninitialized dev
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362607493-5634-1-git-send-email-bhavesh@vmware.com>
References: <1362591984-16587-1-git-send-email-bhavesh@vmware.com>
	<1362607493-5634-1-git-send-email-bhavesh@vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 06 Mar 2013 14:09:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bhavesh Davda <bhavesh@vmware.com>
Date: Wed,  6 Mar 2013 14:04:53 -0800

> Linux is free to call ethtool ops as soon as a netdev exists when probe
> finishes. However, we only allocate vmxnet3 tx/rx queues and initialize the
> rx_buf_per_pkt field in struct vmxnet3_adapter when the interface is
> opened (UP).
> 
> Signed-off-by: Bhavesh Davda <bhavesh@vmware.com>
> Signed-off-by: Shreyas N Bhatewara <sbhatewara@vmware.com>

Maybe this is more appropriate for 'net' rather than 'net-next'?
