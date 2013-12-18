Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3LRJJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:09:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:16046 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab3LRJJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:09:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="454117595"
Date: Wed, 18 Dec 2013 11:15:44 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Qiao Zhou <zhouqiao@marvell.com>
Cc: broonie@linaro.org, haojian.zhuang@gmail.com, zonque@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ssp/pxa2xx: add ssp support for mach-mmp
Message-ID: <20131218091544.GN24938@intel.com>
References: <1387346909-32512-1-git-send-email-zhouqiao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387346909-32512-1-git-send-email-zhouqiao@marvell.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 02:08:29PM +0800, Qiao Zhou wrote:
> mach-mmp also uses ssp request/free APIs. Add mach-mmp support.
> Otherwise there will be redefinition error.
> 
> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
