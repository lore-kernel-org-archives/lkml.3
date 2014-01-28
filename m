Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaA1Jwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:52:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaA1Jws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:52:48 -0500
Date: Tue, 28 Jan 2014 10:54:42 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/9] ipr: Use pci_enable_msi_range() and
 pci_enable_msix_range()
Message-ID: <20140128095441.GA6951@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 05:02:18PM +0100, Alexander Gordeev wrote:
> As result deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Brian, James,

Could you please review patches 3 and 4?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
