Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936393Ab3DHPV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:21:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:29343 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935977Ab3DHPV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:21:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="291776536"
Date: Mon, 8 Apr 2013 17:21:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC v2 1/2] max77693: added device tree support
Message-ID: <20130408152122.GU24058@zurbaran>
References: <1361288177-14452-1-git-send-email-a.hajda@samsung.com>
 <1361288177-14452-2-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361288177-14452-2-git-send-email-a.hajda@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On Tue, Feb 19, 2013 at 04:36:16PM +0100, Andrzej Hajda wrote:
> max77693 mfd main device uses only wakeup field
> from max77693_platform_data. This field is mapped
> to wakeup-source property in device tree.
> Device tree bindings doc will be added in max77693-led patch.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max77693.c |   40 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 7 deletions(-)
This patch looks good to me, but doesn't apply to mfd-next. Would you mind
rebasing it ?

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
