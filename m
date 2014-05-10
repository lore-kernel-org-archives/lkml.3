Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbaEJOPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 10:15:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788AbaEJOPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 10:15:17 -0400
Message-ID: <1399731309.17639.167.camel@ul30vt.home>
Subject: Re: [PATCH v2 00/15] PCI/iommu: Fix DMA alias problems
From: Alex Williamson <alex.williamson@redhat.com>
To: George Spelvin <linux@horizon.com>
Cc: acooks@gmail.com, bhelgaas@google.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Date: Sat, 10 May 2014 08:15:09 -0600
In-Reply-To: <20140510140814.16061.qmail@ns.horizon.com>
References: <20140510140814.16061.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-10 at 10:08 -0400, George Spelvin wrote:
> > What's the device ID of these devices?
> 
> Oops!  It's
> 
> 05:00.0 SATA controller [0106]: Marvell Technology Group Ltd. 88SE9172 SATA 6Gb/s Controller [1b4b:9172] (rev 11)
> 06:00.0 SATA controller [0106]: Marvell Technology Group Ltd. 88SE9172 SATA 6Gb/s Controller [1b4b:9172] (rev 11)
> 07:00.0 SATA controller [0106]: Marvell Technology Group Ltd. 88SE9172 SATA 6Gb/s Controller [1b4b:9172] (rev 11)
> 
> > The dma-alias branch only has the v1 patchset.  There are several more
> > Marvell devices included in the quirks in the v2 set.  Please re-test
> > with this code.  Thanks,
> 
> Oh, okay!  I got the patches from github because it was a lot easier
> to get the whole set that way.  (I don't actually have an SMTP LKML
> subscription, so I have to copy them all from a web archive, then
> manually edit the headers into something RFC822-like enough for "git am"
> to accept.)
> 
> Mea culpa for forgetting to check the version.  And thank you for the response!


Hi George,

I'll post a v3 soon, I think we figured out the problem Andrew was
having, a couple typos on my part.  I'll push out a new branch for that
so you don't need to piece it together yourself.  Thanks,

Alex

