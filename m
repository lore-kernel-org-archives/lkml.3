Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936514Ab3DKDjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:39:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56007 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934792Ab3DKDje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:39:34 -0400
Date: Wed, 10 Apr 2013 23:39:33 -0400 (EDT)
Message-Id: <20130410.233933.2109788843089649198.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: buytenh@wantstofly.org, andrew@lunn.ch, jason@lakedaemon.net,
        florian@openwrt.org, sergei.shtylyov@cogentembedded.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mv643xx_eth: use managed devm_kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365626527-27233-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1365615483-26318-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1365626527-27233-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 10 Apr 2013 20:39:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Wed, 10 Apr 2013 22:42:07 +0200

> This patch moves shared private data kzalloc to managed devm_kzalloc and
> cleans now unneccessary kfree and error handling.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

This doesn't apply cleanly to the net-next tree.
