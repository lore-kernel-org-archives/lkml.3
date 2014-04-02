Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbaDBPS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:18:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337AbaDBPSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:18:55 -0400
Date: Wed, 2 Apr 2014 17:20:44 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 RESEND 4/4] xhci: Use pci_enable_msix_exact() instead
 of pci_enable_msix()
Message-ID: <20140402152044.GA13421@dhcp-26-207.brq.redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
 <606a52afdccf627b6273379b21daffc460b9559a.1394128952.git.agordeev@redhat.com>
 <20140306215646.GA23294@xanatos>
 <20140325142730.GA4518@dhcp-26-207.brq.redhat.com>
 <20140402114127.GA10007@dhcp-26-207.brq.redhat.com>
 <533C1919.3010506@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533C1919.3010506@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 05:05:13PM +0300, Mathias Nyman wrote:
> On 04/02/2014 02:41 PM, Alexander Gordeev wrote:
> >On Tue, Mar 25, 2014 at 03:27:30PM +0100, Alexander Gordeev wrote:
> >>On Thu, Mar 06, 2014 at 01:56:46PM -0800, Sarah Sharp wrote:
> >>>What do you mean by this sentence?  Are you fixing some bug in those two
> >>>functions, or just cleaning up how they look?  Either way, this should
> >>>really be two patches.
> >>Hi Sarah,
> >>
> >>Any feedback on v2?
> >
> 
> Hi

Thank you for the review, Mathias.

> Thanks for the patches,
> I'll  queue patch 2/2  for usb-linus once 3.15-rc1 comes out.
> 
> But I'm going to omit patch 1/2 because it doesn't really improve
> code readability and doesn't change functionality.

I fail to see how it does not improve the readability. It makes the
way the result returned consistent with the rest of the code and
explicitly returns succeess where it is known 'ret' contains zero.

But it surely up to you :)

> At this stage I'd like to avoid extra patches as much as possible.
> And besides, it adds one extra line of code
> 
> -Mathias

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
