Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaDYNtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:49:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:50397 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaDYNtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:49:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="528313771"
Date: Fri, 25 Apr 2014 16:49:46 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mike Turquette <mturquette@linaro.org>, Len Brown <lenb@kernel.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Loic Poulain <loic.poulain@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI / LPSS: Support for fractional divider clock
Message-ID: <20140425134946.GA13638@xps8300>
References: <1398428541-912-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1398428541-912-3-git-send-email-heikki.krogerus@linux.intel.com>
 <1398433454.11914.268.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398433454.11914.268.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 04:44:14PM +0300, Andy Shevchenko wrote:
> Just kasprintf() instead of a few LOCs?

Thanks Andy. I didn't even know about it :).


-- 
heikki
