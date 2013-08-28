Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3H1WZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:25:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50666 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3H1WZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:25:04 -0400
Date: Wed, 28 Aug 2013 18:25:02 -0400 (EDT)
Message-Id: <20130828.182502.839052585388582662.davem@davemloft.net>
To: clbchenlibo.chen@huawei.com
Cc: anirudh@xilinx.com, John.Linn@xilinx.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH] net: xilinx: fix memleak
From: David Miller <davem@davemloft.net>
In-Reply-To: <521ACBEF.7020301@huawei.com>
References: <521ACBEF.7020301@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 28 Aug 2013 15:25:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <clbchenlibo.chen@huawei.com>
Date: Mon, 26 Aug 2013 11:30:55 +0800

> 
>  decrease device_node refcount np1 in err case.
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Applied, thank you.
