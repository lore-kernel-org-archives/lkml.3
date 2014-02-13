Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaBMRwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:52:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaBMRwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:52:20 -0500
Date: Thu, 13 Feb 2014 18:54:19 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 21/22] qla4xxx: Use pci_enable_msix_range()
Message-ID: <20140213175418.GF26610@dhcp-26-207.brq.redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
 <eb9c6c476786ff901512e46859f0d59a5e62170d.1391512266.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb9c6c476786ff901512e46859f0d59a5e62170d.1391512266.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 12:17:07PM +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.

Hi Vikas,

Any feedback on this?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
