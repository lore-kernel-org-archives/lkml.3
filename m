Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaCFVmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:42:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbaCFVmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:42:02 -0500
Date: Thu, 6 Mar 2014 22:43:57 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 1/4] ioat: Use pci_enable_msix_exact() instead
 of pci_enable_msix()
Message-ID: <20140306214356.GA16376@dhcp-26-207.brq.redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
 <2ba22558b5db90740d5833c35570c3e7cc1e359e.1394128952.git.agordeev@redhat.com>
 <CAPcyv4jW19zxApviDdbofbXB1OvvN2sCriL3Paszfk9o3T8x0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jW19zxApviDdbofbXB1OvvN2sCriL3Paszfk9o3T8x0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 01:09:39PM -0800, Dan Williams wrote:
> Can you point me to the background for this change.  From the
> changelog I have no idea what this patch does or why I need to apply
> it.

Function pci_enable_msix() returns a tri-state value while
pci_enable_msi_exact() is a canonical zero/-errno variant.
The former is being phased out in favor of the latter.
In case of 'ioat' there (should be) no difference.

HTH.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
