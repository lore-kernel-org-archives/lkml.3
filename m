Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3JMPqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 11:46:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:11089 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab3JMPqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 11:46:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,486,1378882800"; 
   d="scan'208";a="416219631"
Date: Sun, 13 Oct 2013 20:24:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: misc: remove deprecated IRQF_DISABLED
Message-ID: <20131013145400.GH2954@intel.com>
References: <1381641051-7287-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381641051-7287-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 07:10:51AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.

Applied, thanks. Title shouldnt have misc as it doesnt convey anything.

~Vinod
