Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbbAVJ35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:29:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:59007 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbbAVJ3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:29:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,448,1418112000"; 
   d="scan'208";a="665725151"
Message-ID: <1421918985.31903.113.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/4] x86: pmc_atom: save struct device pointer in pmc
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: x86@kernel.org, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Thu, 22 Jan 2015 11:29:45 +0200
In-Reply-To: <54C07190.3090403@linux.intel.com>
References: <1421790603-30097-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1421790603-30097-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <54C07190.3090403@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 11:42 +0800, Li, Aubrey wrote:
> On 2015/1/21 5:50, Andy Shevchenko wrote:
> > The change allows to use dev_printk() type of macros in the module functions.
> 
> The patch itself looks good to me, but not sure why do we need this
> change, will we use dev_prink in the subsequent patches?

Has no relations to the rest, indeed. Just found that would be easier to
send them together.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

