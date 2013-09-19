Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3ISJNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:13:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35970 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3ISJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:13:54 -0400
Date: Thu, 19 Sep 2013 12:12:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tobias Polzer <bulsa.t.polzer@studium.uni-erlangen.de>
Cc: usbip-devel@lists.sourceforge.net, Dominik Paulus <dominik.paulus@fau.de>,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Tobias Polzer <tobias.polzer@fau.de>,
        linux-kernel@vger.kernel.org, Stefan Reif <ke42caxa@cip.cs.fau.de>
Subject: Re: [PATCH] staging: usbip: Fix build on Debian ppc
Message-ID: <20130919091244.GV25896@mwanda>
References: <1379579978-2570-1-git-send-email-dominik.paulus@fau.de>
 <op.w3nhqgkq423x8j@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.w3nhqgkq423x8j@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 10:55:18AM +0200, Tobias Polzer wrote:
> When testing usbip under powerpc, it (unexpectedly) worked, but only after
> removing the following lines from vhch_hcd.c:
> 
> 1004         /* will be removed */
> 1005         if (pdev->dev.dma_mask) {
> 1006                 dev_info(&pdev->dev, "vhci_hcd DMA not supported\n");
> 1007                 return -EINVAL;
> 1008         }
> 
> We encountered no problems without those lines. Is it safe to remove this
> check?

Hehe.  No.

Also which vhch_hcd.c are you talking about?  "find -name vhch_hcd.c"
doesn't show anything.

What the error message?

regards,
dan carpenter

