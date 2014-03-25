Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaCYUNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:13:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaCYUNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:13:42 -0400
Date: Tue, 25 Mar 2014 15:27:31 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 RESEND 4/4] xhci: Use pci_enable_msix_exact() instead
 of pci_enable_msix()
Message-ID: <20140325142730.GA4518@dhcp-26-207.brq.redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
 <606a52afdccf627b6273379b21daffc460b9559a.1394128952.git.agordeev@redhat.com>
 <20140306215646.GA23294@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306215646.GA23294@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 01:56:46PM -0800, Sarah Sharp wrote:
> What do you mean by this sentence?  Are you fixing some bug in those two
> functions, or just cleaning up how they look?  Either way, this should
> really be two patches.

Hi Sarah,

Any feedback on v2?

Thanks!

> Sarah Sharp

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
