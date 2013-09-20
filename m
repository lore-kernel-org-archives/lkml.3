Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3ITSlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:41:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39282 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab3ITSlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:41:15 -0400
Date: Fri, 20 Sep 2013 14:41:14 -0400 (EDT)
Message-Id: <20130920.144114.821790857141050930.davem@davemloft.net>
To: michal.simek@xilinx.com
Cc: netdev@vger.kernel.org, monstr@monstr.eu, renner@efe-gmbh.de,
        libo.chen@huawei.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: emaclite: Not necessary to call devm_iounmap
From: David Miller <davem@davemloft.net>
In-Reply-To: <196d8368eee2d45eeeab40e96e2971f78ed8a79b.1378969499.git.michal.simek@xilinx.com>
References: <196d8368eee2d45eeeab40e96e2971f78ed8a79b.1378969499.git.michal.simek@xilinx.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 20 Sep 2013 11:41:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>
Date: Thu, 12 Sep 2013 09:05:10 +0200

> devm_iounmap is called automatically.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Applied to net-next
