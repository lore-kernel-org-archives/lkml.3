Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891Ab3JQEzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 00:55:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35942 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab3JQEzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 00:55:31 -0400
Date: Thu, 17 Oct 2013 00:55:29 -0400 (EDT)
Message-Id: <20131017.005529.65774633845257668.davem@davemloft.net>
To: vinod.koul@intel.com
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 28/28] net: use DMA_COMPLETE for dma completion status
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381940926-25564-29-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
	<1381940926-25564-29-git-send-email-vinod.koul@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 16 Oct 2013 21:55:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>
Date: Wed, 16 Oct 2013 21:58:46 +0530

> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> CC: "David S. Miller" <davem@davemloft.net>

Acked-by: David S. Miller <davem@davemloft.net>
