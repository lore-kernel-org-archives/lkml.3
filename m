Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3AVDbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:31:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:64216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab3AVDbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:31:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="280280326"
Date: Tue, 22 Jan 2013 04:31:05 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Harald Welte <laforge@openmoko.org>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: pcf50633: Init pcf->dev before using it
Message-ID: <20130122033105.GX7409@sortiz-mobl>
References: <1356403969.22368.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356403969.22368.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Dec 25, 2012 at 10:52:49AM +0800, Axel Lin wrote:
> Current code uses pcf->dev in the dev_err call before setting it to
> &client->dev. Fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/pcf50633-core.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
Applied to my for-linus branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
