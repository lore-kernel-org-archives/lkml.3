Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841AbaLLKK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:10:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:20935 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934677AbaLLKK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:10:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,561,1413270000"; 
   d="scan'208";a="652782815"
Message-ID: <1418379009.17201.61.camel@linux.intel.com>
Subject: Re: [PATCH v1 0/4] mfd: reorganize Intel drivers
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Fri, 12 Dec 2014 12:10:09 +0200
In-Reply-To: <1418314017.18092.35.camel@perches.com>
References: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1418314017.18092.35.camel@perches.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-11 at 08:06 -0800, Joe Perches wrote:
> On Thu, 2014-12-11 at 17:53 +0200, Andy Shevchenko wrote:
> > This patchset creates a new folder under drivers/mfd and moves there Intel
> > related drivers.
> 
> Missing update of MAINTAINERS?

Oh, right. I could send a follow up patch or update each patch in the
series. What is the best approach here?

Will wait for more comments, especially from Lee.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

