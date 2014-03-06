Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbaCFBsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:48:00 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51793 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaCFBr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:47:58 -0500
Date: Wed, 05 Mar 2014 20:47:57 -0500 (EST)
Message-Id: <20140305.204757.2283708731367425686.davem@davemloft.net>
To: soren.brinkmann@xilinx.com
Cc: nicolas.ferre@atmel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, michal.simek@xilinx.com, ben@decadent.org.uk
Subject: Re: [PATCH v3 2/2] net: macb: DMA-unmap full rx-buffer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393951600-26039-2-git-send-email-soren.brinkmann@xilinx.com>
References: <1393951600-26039-1-git-send-email-soren.brinkmann@xilinx.com>
	<1393951600-26039-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Mar 2014 17:47:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Soren Brinkmann <soren.brinkmann@xilinx.com>
Date: Tue,  4 Mar 2014 08:46:40 -0800

> When allocating RX buffers a fixed size is used, while freeing is based
> on actually received bytes, resulting in the following kernel warning
> when CONFIG_DMA_API_DEBUG is enabled:
 ...
> Fixing this by passing the same size which is passed during mapping the
> memory to the unmap function as well.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Applied.
