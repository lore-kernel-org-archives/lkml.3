Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbaDBLrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:47:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758197AbaDBLrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:47:46 -0400
Date: Wed, 2 Apr 2014 13:49:32 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org, iss_storagedev@hp.com,
        intel-linux-scu@intel.com, support@lsi.com, DL-MPTFusionLinux@lsi.com,
        qla2xxx-upstream@qlogic.com, iscsi-driver@qlogic.com,
        pv-drivers@vmware.com, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 00/23] scsi: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140402114932.GB10007@dhcp-26-207.brq.redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
 <20140313040440.GB26657@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313040440.GB26657@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 10:04:40PM -0600, Bjorn Helgaas wrote:
> Hi James,
> 
> I think Alexander sent these to linux-scsi hoping that you would handle
> them, but I know it's a hassle because they depend on f7fc32c, which went
> in after the merge window.
> 
> I'd be glad to review these and apply them through my tree, unless you want
> to do it.  I'd like to get these merged in the v3.15 merge window so
> Alexander can move on to something else.  I haven't checked for merge
> conflicts with scsi.git yet, but I assume they'd be pretty trivial if there
> are any.

Hi Bjorn,

It has shifted to v3.16, right?

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
