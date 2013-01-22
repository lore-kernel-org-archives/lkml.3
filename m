Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab3AVDY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:24:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:34243 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab3AVDYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:24:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="276778659"
Date: Tue, 22 Jan 2013 04:24:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: max77686: Init max77686->dev before using it
Message-ID: <20130122032450.GF7409@sortiz-mobl>
References: <1356365803.17063.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356365803.17063.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Dec 25, 2012 at 12:16:43AM +0800, Axel Lin wrote:
> Current code uses max77686->dev in the dev_err call before setting it to
> &i2c->dev. Fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/max77686.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
Applied to my for-linus branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
