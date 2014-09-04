Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaIDNUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:20:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaIDNUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:20:38 -0400
Date: Thu, 4 Sep 2014 14:29:39 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/13] lpfc: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140904132939.GA1225@agordeev.usersys.redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
 <e7470e484083c9eeb6b4f34f3e69e332ad5998c2.1408335523.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7470e484083c9eeb6b4f34f3e69e332ad5998c2.1408335523.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 08:01:51AM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

James?

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
