Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3COGog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:44:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:23504 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3COGoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:44:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="215022991"
Date: Fri, 15 Mar 2013 07:43:31 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] mfd: remove __exit_p annotation for
 twl4030_madc_remove
Message-ID: <20130315064331.GC12559@zurbaran>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363298204-8014-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Mar 14, 2013 at 10:56:38PM +0100, Arnd Bergmann wrote:
> 4740f73fe5 "mfd: remove use of __devexit" removed the __devexit annotation
> on the twl4030_madc_remove function, but left an __exit_p() present on the
> pointer to this function. Using __exit_p was as wrong with the devexit in
> place as it is now, but now we get a gcc warning about an unused function.
> 
> In order for the twl4030_madc_remove to work correctly in built-in code, we
> have to remove the __exit_p.
> 
> Cc: Bill Pemberton <wfp5p@virginia.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> 
> Please apply to MFD tree for 3.9
> 
>  drivers/mfd/twl4030-madc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied to mfd-fixes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
