Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbaDBLjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:39:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559AbaDBLjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:39:39 -0400
Date: Wed, 2 Apr 2014 13:41:27 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 RESEND 4/4] xhci: Use pci_enable_msix_exact() instead
 of pci_enable_msix()
Message-ID: <20140402114127.GA10007@dhcp-26-207.brq.redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
 <606a52afdccf627b6273379b21daffc460b9559a.1394128952.git.agordeev@redhat.com>
 <20140306215646.GA23294@xanatos>
 <20140325142730.GA4518@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140325142730.GA4518@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 03:27:30PM +0100, Alexander Gordeev wrote:
> On Thu, Mar 06, 2014 at 01:56:46PM -0800, Sarah Sharp wrote:
> > What do you mean by this sentence?  Are you fixing some bug in those two
> > functions, or just cleaning up how they look?  Either way, this should
> > really be two patches.
> 
> Hi Sarah,
> 
> Any feedback on v2?

Sarah?

> Thanks!
> 
> > Sarah Sharp
> 
> -- 
> Regards,
> Alexander Gordeev
> agordeev@redhat.com

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
