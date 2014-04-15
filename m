Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaDOAMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:12:12 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51698 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbaDOAMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:12:10 -0400
Date: Mon, 14 Apr 2014 18:12:07 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dugger <donald.d.dugger@intel.com>
Subject: Re: [PATCH] PCI: Add Patsburg (X79) to Intel PCH root port ACS quirk
Message-ID: <20140415001207.GE16058@google.com>
References: <20140331182113.23398.38246.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331182113.23398.38246.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 12:21:38PM -0600, Alex Williamson wrote:
> Intel has updated Red Hat bz1037684 to note that X79 PCH root ports
> also provide isolation and the same ACS quirks apply.  Some sources
> indicate additional device IDs for X79, but this patch includes only
> the ones specifically identified by Intel:
> https://bugzilla.redhat.com/show_bug.cgi?id=1037684#c11
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: Don Dugger <donald.d.dugger@intel.com>

Applied with Don's ack to pci/virtualization for v3.16, thanks!

> ---
>  drivers/pci/quirks.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index e729206..5e4ac63 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3453,6 +3453,8 @@ static const u16 pci_quirk_intel_pch_acs_ids[] = {
>  	/* Wildcat PCH */
>  	0x9c90, 0x9c91, 0x9c92, 0x9c93, 0x9c94, 0x9c95, 0x9c96, 0x9c97,
>  	0x9c98, 0x9c99, 0x9c9a, 0x9c9b,
> +	/* Patsburg (X79) PCH */
> +	0x1d10, 0x1d12, 0x1d14, 0x1d16, 0x1d18, 0x1d1a, 0x1d1c, 0x1d1e,
>  };
>  
>  static bool pci_quirk_intel_pch_acs_match(struct pci_dev *dev)
> 
