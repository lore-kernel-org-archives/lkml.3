Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3BAGtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 01:49:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43020 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3BAGtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 01:49:03 -0500
Date: Fri, 1 Feb 2013 09:48:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH] drivers: android: Restructure code in lowmemorykiller
Message-ID: <20130201064841.GB4937@mwanda>
References: <510AE2D6.6010101@semaphore.gr>
 <20130131222511.GA21654@kroah.com>
 <510AF4B0.7090002@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510AF4B0.7090002@semaphore.gr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 12:48:16AM +0200, Stratos Karafotis wrote:
> I will fix it.

I don't know the status of this driver.

But in general the patch should have been divided up into smaller
changes and sent as a patchset.  It creates a bunch of messy new
globals where it would have been cleaner to use function parameters.
Don't introduce new calls to lowmem_print() because we have better
debugging facilities already in the kernel and don't need more.

Btw, the more things you put into one patch, the more there is to
complain about and the less likely it is to be merged.

regards,
dan carpenter
