Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab3LIJwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:52:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:51204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760460Ab3LIJwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:52:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,856,1378882800"; 
   d="scan'208";a="446875881"
Message-ID: <1386582730.1871.109.camel@smile>
Subject: Re: [PATCH] SFI: remove wrong FSF address from the license
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
Date: Mon, 09 Dec 2013 11:52:10 +0200
In-Reply-To: <52A590CC.4040703@nvidia.com>
References: <1386581527-28907-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <52A590CC.4040703@nvidia.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 18:43 +0900, Alex Courbot wrote:
> On 12/09/2013 06:32 PM, Andy Shevchenko wrote:
> > Remove old and currently wrong address of the FSF from license parts of the
> > code.
> 
> The address is not wrong, it is just that you don't want to see it 
> become wrong should it change in the future.

Oh, I have misread that.
So, this patch probably is not needed at all.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

