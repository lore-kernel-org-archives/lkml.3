Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaILWQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:16:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51963 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaILWQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:16:08 -0400
Date: Fri, 12 Sep 2014 18:16:05 -0400 (EDT)
Message-Id: <20140912.181605.1878319812562851527.davem@davemloft.net>
To: subbaraya.sundeep.bhatta@xilinx.com
Cc: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michals@xilinx.com, svemula@xilinx.com, anirudh@xilinx.com,
        sbhatta@xilinx.com
Subject: Re: [PATCH] net: axienet: remove unnecessary ether_setup after
 alloc_etherdev
From: David Miller <davem@davemloft.net>
In-Reply-To: <78ce1faf-0bf8-41bb-a30d-cecd11d82d94@BY2FFO11FD033.protection.gbl>
References: <78ce1faf-0bf8-41bb-a30d-cecd11d82d94@BY2FFO11FD033.protection.gbl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Sep 2014 15:16:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
Date: Thu, 11 Sep 2014 14:53:33 +0530

> calling ether_setup is redundant since alloc_etherdev calls
> it.
> 
> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>

Applied.
