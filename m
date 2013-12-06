Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab3LFSqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:46:06 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36542 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217Ab3LFSqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:46:03 -0500
X-Sasl-enc: FwSnIfoMTb9YmFsCVMas0r7UH+WuuJqAXTd2Y8rpFMsY 1386355562
Date: Fri, 6 Dec 2013 10:46:01 -0800
From: Greg KH <greg@kroah.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Subject: Re: Nov. Fedora Kernel Patch Report
Message-ID: <20131206184601.GD4379@kroah.com>
References: <CA+5PVA6Mh=tRM5h=TCbg5yjkkFUg2OncJmHBdtBhG7jqf377rg@mail.gmail.com>
 <CA+5PVA4pXtXHWzeSnx7d9eGEiOQ-jtL2RtBEyqxmz2DemT--jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4pXtXHWzeSnx7d9eGEiOQ-jtL2RtBEyqxmz2DemT--jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 06:56:24PM -0500, Josh Boyer wrote:
> > vfio-iommu-Fixed-interaction-of-VFIO_IOMMU_MAP_DMA.patch (rhbz 998732)
> > - In 3.13
> 
> commit f9423606ade08653dd8a43334f0a7fb45504c5cc

Thanks for this one, now got it, no one told me about that one...

> 
> > iommu-Remove-stack-trace-from-broken-irq-remapping-warning.patch (rhbz 982153)
> > - In 3.13
> 
> commit 05104a4e8713b27291c7bb49c1e7e68b4e243571

Now applied.

> > rt2800-add-support-for-rf3070.patch (rhbz 974072)
> > - In 3.13
> 
> commit 3b9b74baa1af2952d719735b4a4a34706a593948

Now applied.

> > elevator-Fix-a-race-in-elevator-switching-and-md.patch
> > elevator-acquire-q-sysfs_lock-in-elevator_change.patch (rhbz 902012)
> > - In 3.13
> 
> commit eb1c160b22655fd4ec44be732d6594fd1b1e44f4 and
> 7c8a3679e3d8e9d92d58f282161760a0e247df97

Now applied.

> > ntp-Make-periodic-RTC-update-more-reliable.patch (rhbz 985522)
> > - In 3.13
> 
> commit a97ad0c4b447a132a322cedc3a5f7fa4cab4b304

Applied.

Thanks so much for the list, much appreciated.

greg k-h
