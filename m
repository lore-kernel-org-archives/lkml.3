Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbbAEK7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:59:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbbAEK7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:59:42 -0500
Date: Mon, 5 Jan 2015 11:59:37 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Myron Stowe <mstowe@redhat.com>
Subject: Re: [PATCH 1/2] iommu/vt-d: Fix dmar_domain leak in
 iommu_attach_device
Message-ID: <20150105105937.GA6638@suse.de>
References: <1418813017-24888-1-git-send-email-joro@8bytes.org>
 <20141217213747.GA11569@anatevka.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217213747.GA11569@anatevka.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jerry,

On Wed, Dec 17, 2014 at 02:37:47PM -0700, Jerry Hoemann wrote:
> Before applying this change on a 3.18-rc7 kernel layered on a
> RHEL 7.0 root disk, I was able to reproduce the memory
> leak that Alex reported when powering on/off a VM w/ a PCI
> device assigned to it.
> 
> After applying this change, I don't see the memory leak anymore.
> Instrumentation shows the new code is being invoked during power on
> of the VM.
> 
> Looks good.
> 
> Thanks!
> 
> Tested-by: Jerry Hoemann <jerry.hoemann@hp.com>

Thanks for testing, I applied the patches to my iommu/fixes branch for
3.19.


	Joerg

