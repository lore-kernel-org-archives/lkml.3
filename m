Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3I1CoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 22:44:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38002 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab3I1CoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 22:44:08 -0400
Date: Fri, 27 Sep 2013 20:44:05 -0600
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: Re: [PATCH 1/1] rsxx: Kernel Panic caused by mapping Discards.
Message-ID: <20130928024405.GC4157@kernel.dk>
References: <20130928002658.GB13456@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928002658.GB13456@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27 2013, Philip J. Kelleher wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> This fixes a kernel panic injected by commit id
> 8d26750143341831bc312f61c5ed141eeb75b8d0 where discards
> are getting mapped through the pci_map_page function call.
> 
> The driver will now start verifying that a dma is not a
> discard before issuing a the pci_map_page function call.
> 
> Also, we are updating the driver version.

Thanks, applied.

-- 
Jens Axboe

