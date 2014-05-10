Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaEJQQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 12:16:39 -0400
Received: from ns.horizon.com ([71.41.210.147]:25435 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750912AbaEJQQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 12:16:37 -0400
Date: 10 May 2014 12:16:36 -0400
Message-ID: <20140510161636.25044.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: alex.williamson@redhat.com, linux@horizon.com
Subject: Re: [PATCH v2 00/15] PCI/iommu: Fix DMA alias problems
Cc: acooks@gmail.com, bhelgaas@google.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <1399731309.17639.167.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll post a v3 soon, I think we figured out the problem Andrew was
> having, a couple typos on my part.  I'll push out a new branch for that
> so you don't need to piece it together yourself.  Thanks,

Don't worry; I imported v2, and have it running successfully right now.
I ran e2fsck and hdparm -t on a couple of drives on the controller
(including in parallel), with no problems.

Again, sorry for my earlier laziness.
