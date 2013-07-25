Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3GYJSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:18:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:44846 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab3GYJSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:18:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,742,1367996400"; 
   d="scan'208";a="370722071"
Date: Thu, 25 Jul 2013 14:10:28 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 05/36] dma: convert dma_devclass to use dev_groups
Message-ID: <20130725084028.GL18642@intel.com>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-6-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374703539-9705-6-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 03:05:08PM -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the dma dma_devclass code to use
> the correct field.
> 
> Cc: Dan Williams <djbw@fb.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Vinod Koul <vinod.koul@intel.com>

~Vinod
