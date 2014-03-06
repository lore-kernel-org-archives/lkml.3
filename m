Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbaCFBru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:47:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51787 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859AbaCFBrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:47:49 -0500
Date: Wed, 05 Mar 2014 20:47:47 -0500 (EST)
Message-Id: <20140305.204747.1926579810397332616.davem@davemloft.net>
To: soren.brinkmann@xilinx.com
Cc: nicolas.ferre@atmel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, michal.simek@xilinx.com, ben@decadent.org.uk
Subject: Re: [PATCH v3 1/2] net: macb: Check DMA mappings for error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393951600-26039-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1393951600-26039-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Mar 2014 17:47:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Soren Brinkmann <soren.brinkmann@xilinx.com>
Date: Tue,  4 Mar 2014 08:46:39 -0800

> With CONFIG_DMA_API_DEBUG enabled the following warning is printed:
 ...
> due to missing checks of the dma mapping. Add the appropriate checks to fix
> this.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Applied.
