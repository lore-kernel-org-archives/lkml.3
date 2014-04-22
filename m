Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbaDVQOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:14:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:9963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178AbaDVQOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,904,1389772800"; 
   d="scan'208";a="524994169"
Date: Tue, 22 Apr 2014 21:32:28 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: dan.j.williams@intel.com, nsekhar@ti.com, joelf@ti.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH v3 09/10] dmaengine: edma: Add channel number to debug
 prints
Message-ID: <20140422160228.GW32284@intel.com>
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
 <1397475725-5036-10-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397475725-5036-10-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 02:42:04PM +0300, Peter Ujfalusi wrote:
> It helps to identify issues if we have some information regarding to the
> channel which the event is associated.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Acked-by: Joel Fernandes <joelf@ti.com>

This failed to apply, cna you pls rebase this and resend...

--	
~Vinod
