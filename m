Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaBVJiD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 04:38:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaBVJiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 04:38:00 -0500
Date: Sat, 22 Feb 2014 10:38:43 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Mike Miller <mike.miller@hp.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, iss_storagedev@hp.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/9] block: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140222093843.GB27897@dhcp-26-207.brq.redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
 <20140221234613.GE29129@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221234613.GE29129@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 03:46:13PM -0800, Jens Axboe wrote:
> On Wed, Feb 19 2014, Alexander Gordeev wrote:
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers
> > using these two interfaces need to be updated to use the
> > new pci_enable_msi_range() and pci_enable_msix_range()
> > interfaces.
> 
> Thanks. Applied 3-4, and 6-9 (didn't get the others).

Oh, I just realized I posted outdated series, sorry for that :(
Out of applied patch 4 is not needed and patch 9 needs a rework.

Should I repost the whole series?

> -- 
> Jens Axboe

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
