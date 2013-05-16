Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3EPWPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:15:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:51223 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab3EPWPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:15:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="338562568"
Date: Fri, 17 May 2013 00:15:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC 13/42] drivers/mfd: don't check resource with
 devm_ioremap_resource
Message-ID: <20130516221529.GL22822@zurbaran>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-14-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368173847-5661-14-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

On Fri, May 10, 2013 at 10:16:58AM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/mfd/intel_msic.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
