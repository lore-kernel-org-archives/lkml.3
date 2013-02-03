Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3BCWcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 17:32:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:59847 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab3BCWcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 17:32:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="198290582"
Date: Sun, 3 Feb 2013 23:32:37 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk
Subject: Re: [PATCH 33/62] mfd: convert to idr_alloc()
Message-ID: <20130203223237.GB8476@sortiz-mobl>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-34-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-34-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Sat, Feb 02, 2013 at 05:20:34PM -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.
I'm fine with it. I already have some rtsx changes queued for the next merge
window so that may trigger some conflicts. We'll see.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
