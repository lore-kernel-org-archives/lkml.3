Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277Ab3DDOuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:50:44 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53728 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761988Ab3DDOum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:50:42 -0400
Date: Thu, 4 Apr 2013 10:50:12 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130404145012.GA3403@neilslaptop.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com>
 <CAErSpo4=L9q+q5hqP2Avw6uceQwZiPuOzadhsqGpu6aP53PMbQ@mail.gmail.com>
 <1365085649.28127.66.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365085649.28127.66.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 03:27:29PM +0100, David Woodhouse wrote:
> On Wed, 2013-04-03 at 17:53 -0600, Bjorn Helgaas wrote:
> > );
> > > +
> > > +       if ((revision == 0x13) && irq_remapping_enabled) {
> > > +                pr_warn(HW_ERR "This system BIOS has enabled interrupt remapping\n"
> > > +                        "on a chipset that contains an errata making that\n"
> > > +                        "feature unstable.  Please reboot with nointremap\n"
> > > +                        "added to the kernel command line and contact\n"
> > > +                        "your BIOS vendor for an update");
> 
> This should be WARN_TAINT(TAINT_FIRMWARE_WORKAROUND). And 'an erratum'.
> 
Ok, copy that. I'll repost shortly

> -- 
> dwmw2


