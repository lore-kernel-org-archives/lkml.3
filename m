Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaBSINu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:13:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbaBSINt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:13:49 -0500
Date: Wed, 19 Feb 2014 09:15:42 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>
Cc: pv-drivers@vmware.com, iscsi-driver@qlogic.com,
        qla2xxx-upstream@qlogic.com, support@lsi.com,
        DL-MPTFusionLinux@lsi.com, intel-linux-scu@intel.com,
        iss_storagedev@hp.com, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 00/22] scsi: Use pci_enable_msix_range()
Message-ID: <20140219081541.GA26928@dhcp-26-207.brq.redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 12:16:46PM +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.

Hi James,

What is the process to get these patches accepted to scsi.git tree?
Should I make some extra effort besides just posting the series this way?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
