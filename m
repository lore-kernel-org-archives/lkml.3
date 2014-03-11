Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaCKK5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:57:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:17111 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbaCKK5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:57:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,630,1389772800"; 
   d="scan'208";a="497599329"
Date: Tue, 11 Mar 2014 16:23:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: George Cherian <george.cherian@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        dmaengine@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        dan.j.williams@intel.com, msmucr@gmail.com
Subject: Re: [PATCH 0/2] Fix CPPI Warnings during tear down after  ISOCH
 transfers
Message-ID: <20140311105308.GT1976@intel.com>
References: <1393478081-14226-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393478081-14226-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:44:39AM +0530, George Cherian wrote:
> Warinings are seen after  ISOCH transfers, during channel tear down.
> This is mainly beacause we handle ISOCH differently as compared to 
> other transfers. 
> 
> Patch 1: make sure we do channel tear down only if channel is busy.
> 	 If not the tear down will never succeed.
> 
> Patch 2: ISOCH completions are done differently, so this might lead to 
> 	reprogram of dma channel on which already a teardown is done.
Applied, Thanks

-- 
~Vinod
