Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3LSTYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:24:09 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:59923 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3LSTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:24:06 -0500
Date: Thu, 19 Dec 2013 20:23:52 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>, rashika.kheria@gmail.com,
        linux-kernel@vger.kernel.org, dvhart@linux.intel.com, joe@perches.com,
        andriy.shevchenko@linux.intel.com, vfalico@redhat.com,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH] drivers: ptp: Include new header file in ptp_pch.c
Message-ID: <20131219192352.GA14612@netboy>
References: <1387140255-11797-1-git-send-email-rashika.kheria@gmail.com>
 <20131216085839.GA8303@netboy>
 <20131218.174359.2230195267384857675.davem@davemloft.net>
 <20131219072757.GB4281@netboy>
 <1387480400.1876.32.camel@bwh-desktop.uk.level5networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387480400.1876.32.camel@bwh-desktop.uk.level5networks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 07:13:20PM +0000, Ben Hutchings wrote:
> 
> PTP is no longer a compile-time option in most net drivers.

Right, for those drivers where there is little or no performance
impact, there is no good reason not to enable the PTP bits.

But if the PTP code entails a run time cost, then we want it to be
optional, but not as a separate module. I suspect that the pch device
falls into this category, but I am not sure without taking another
look.

Thanks,
Richard
