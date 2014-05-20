Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079AbaETF5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:57:33 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62559 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaETF5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:57:31 -0400
Date: Mon, 19 May 2014 22:57:41 -0700
From: Olof Johansson <olof@lixom.net>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, joelf@ti.com,
        linux@arm.linux.org.uk, vinod.koul@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH] ARM: edma: Clean up and simplify the code around irq
 request
Message-ID: <20140520055741.GR18956@quad.lixom.net>
References: <1399965961-23739-1-git-send-email-peter.ujfalusi@ti.com>
 <5374AD6D.8090002@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5374AD6D.8090002@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 05:35:01PM +0530, Sekhar Nori wrote:
> + ARM SoC team
> 
> On Tuesday 13 May 2014 12:56 PM, Peter Ujfalusi wrote:
> > Get the two interrupt line number at the same time by merging the two
> > instance of if(node){}else{} places.
> > replace the &pdev->dev with the already existing dev which makes it possible
> > to collapse lines with devm_request_irq()
> > 
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> 
> Arnd, Olof, Kevin,
> 
> Do you mind applying this directly for v3.16? I do not have anything
> else queued ATM so not sending a pull request.

I see it was reposted today as part of a larger patch set with some
question as to what it applies to.

Sekhar, if you just have one patch for us to apply, then feel free to
resend it to use (git send-email --to=arm@kernel.org) and make it clear
(below the --- separator) that you want us to apply it directly, and
we'll be happy to do so.


-Olof
