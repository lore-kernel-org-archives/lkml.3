Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaBMXIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:08:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51131 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaBMXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:08:03 -0500
Date: Thu, 13 Feb 2014 18:08:00 -0500 (EST)
Message-Id: <20140213.180800.778415248437011159.davem@davemloft.net>
To: michal.simek@xilinx.com
Cc: netdev@vger.kernel.org, sthokal@xilinx.com, monstr@monstr.eu,
        anirudh@xilinx.com, John.Linn@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: axienet: Fix compilation error
From: David Miller <davem@davemloft.net>
In-Reply-To: <2082312fdbceca394080302b1709a5f71d7d3652.1392275432.git.michal.simek@xilinx.com>
References: <cover.1392275432.git.michal.simek@xilinx.com>
	<cover.1392275432.git.michal.simek@xilinx.com>
	<2082312fdbceca394080302b1709a5f71d7d3652.1392275432.git.michal.simek@xilinx.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 15:08:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>
Date: Thu, 13 Feb 2014 08:10:42 +0100

> Add missing header to fix compilation error.
> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1575:22:
>  error: undefined identifier 'irq_of_parse_and_map'
> drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1576:22:
>  error: undefined identifier 'irq_of_parse_and_map'
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Applied.
