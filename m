Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030665AbaGCJfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:35:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:50802 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030626AbaGCJfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:35:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,594,1400050800"; 
   d="scan'208";a="564632607"
Message-ID: <1404380071.5102.57.camel@smile.fi.intel.com>
Subject: Re: [PATCH 1/6] lib / string_helpers: clean up test suite
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 03 Jul 2014 12:34:31 +0300
In-Reply-To: <20140702145410.e1885ad85c25a6f4b6cef2c4@linux-foundation.org>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404307229-19186-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140702145410.e1885ad85c25a6f4b6cef2c4@linux-foundation.org>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 14:54 -0700, Andrew Morton wrote:
> On Wed,  2 Jul 2014 16:20:24 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

[]

> > +	pr_err("Test '%s' failed: flags = %u\n", name, flags);
> > +
> > +	print_hex_dump(KERN_WARNING, "Input: ", DUMP_PREFIX_NONE, 16, 1,
> > +		       in, p, true);
> > +	print_hex_dump(KERN_WARNING, "Expected: ", DUMP_PREFIX_NONE, 16, 1,
> > +		       out_test, q_test, true);
> > +	print_hex_dump(KERN_WARNING, "Got: ", DUMP_PREFIX_NONE, 16, 1,
> > +		       out_real, q_real, true);
> 
> Seems strange to mix KERN_ERR and KERN_WARNING.  The code's always been
> that way, but maybe it can be improved.

Will fix this.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

