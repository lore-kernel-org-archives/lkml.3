Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3FCHtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:49:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38225 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3FCHtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:49:17 -0400
Date: Mon, 03 Jun 2013 00:49:16 -0700 (PDT)
Message-Id: <20130603.004916.406462343477494169.davem@davemloft.net>
To: wangyijing@huawei.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, guohanjun@huawei.com,
        liuj97@gmail.com
Subject: Re: [PATCH] tg3: remove redundant pm init code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1370244981-11716-1-git-send-email-wangyijing@huawei.com>
References: <1370244981-11716-1-git-send-email-wangyijing@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>
Date: Mon, 3 Jun 2013 15:36:21 +0800

> Pci_enable_device() will set device pm state to D0, so
> it's no need to do it again in tg3_init_one().
> 
> Acked-by: Michael Chan <mchan@broadcom.com>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

This looks better, applied, thanks.
