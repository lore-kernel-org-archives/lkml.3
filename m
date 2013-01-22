Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3AVDbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:31:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:28464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab3AVDbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:31:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="274986940"
Date: Tue, 22 Jan 2013 04:30:53 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: max77693: Init max77693->dev before using it
Message-ID: <20130122033053.GW7409@sortiz-mobl>
References: <1356365803.17063.0.camel@phoenix>
 <1356366516.17063.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356366516.17063.5.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Dec 25, 2012 at 12:28:36AM +0800, Axel Lin wrote:
> Current code uses max77693->dev in the dev_err call before setting it to
> &i2c->dev. Fix it.
> 
> This patch also includes below cleanups:
>  - Move checking pdata earlier and show dev_err if no platform data found.
>  - Remove unnecessary err_regmap goto label.
>  - Unregister i2c devices if regmap init for muic fails.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/max77693.c |   34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
