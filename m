Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3BORpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:45:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:31150 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab3BORpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:45:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,674,1355126400"; 
   d="scan'208";a="257561089"
Date: Fri, 15 Feb 2013 18:45:06 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lpc_ich: use devres API to allocate private data
Message-ID: <20130215174506.GA18295@sortiz-mobl>
References: <774339a2-e7cc-4204-a935-0a1b59e2ece8@zimbra>
 <9be5e8ee-d1b9-4509-b147-879281e10efc@zimbra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9be5e8ee-d1b9-4509-b147-879281e10efc@zimbra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arron,

On Thu, Feb 14, 2013 at 11:35:04AM -0600, Aaron Sierra wrote:
> 
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> ---
>  drivers/mfd/lpc_ich.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
