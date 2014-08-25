Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaHYIPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:15:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:23272 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbaHYIPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:15:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="472248598"
Message-ID: <1408954526.30155.2.camel@linux.intel.com>
Subject: Re: [PATCH v3 04/11] lib/vsprintf: add %*pE[achnops] format
 specifier
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 25 Aug 2014 11:15:26 +0300
In-Reply-To: <1408546008.23250.23.camel@joe-AO725>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408527772-27224-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408546008.23250.23.camel@joe-AO725>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 07:46 -0700, Joe Perches wrote:
> On Wed, 2014-08-20 at 12:42 +0300, Andy Shevchenko wrote:
> > This allows user to print a given buffer as an escaped string. The rules are
> > applied according to an optional mix of flags provided by additional format
> > letters.
> 
> Thanks Andy.  Looks good to me.

Can I imply your Reviewed-by?


> Very trivial note:

Fixed locally. Waiting for few days for more comments and will send v5
then.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

