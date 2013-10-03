Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3JCWlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:41:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab3JCWld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:41:33 -0400
Date: Thu, 3 Oct 2013 15:41:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: alexander.shishkin@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] usb: chipidea: add Intel Clovertrail pci id
Message-ID: <20131003224132.GA8465@kroah.com>
References: <1380663178-24218-1-git-send-email-david.a.cohen@linux.intel.com>
 <1380663178-24218-2-git-send-email-david.a.cohen@linux.intel.com>
 <20131003052134.GA1312@kroah.com>
 <524D9574.20702@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D9574.20702@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 09:04:04AM -0700, David Cohen wrote:
> Hi Greg,
> 
> On 10/02/2013 10:21 PM, Greg KH wrote:
> >On Tue, Oct 01, 2013 at 02:32:58PM -0700, David Cohen wrote:
> >>Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> >>---
> >>  drivers/usb/chipidea/ci_hdrc_pci.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >>diff --git a/drivers/usb/chipidea/ci_hdrc_pci.c b/drivers/usb/chipidea/ci_hdrc_pci.c
> >>index 08a724b..d514332 100644
> >>--- a/drivers/usb/chipidea/ci_hdrc_pci.c
> >>+++ b/drivers/usb/chipidea/ci_hdrc_pci.c
> >>@@ -129,6 +129,11 @@ static DEFINE_PCI_DEVICE_TABLE(ci_hdrc_pci_id_table) = {
> >>  		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0829),
> >>  		.driver_data = (kernel_ulong_t)&penwell_pci_platdata,
> >>  	},
> >>+	{
> >>+		/* Intel Clovertrail */
> >>+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe006),
> >>+		.driver_data = (kernel_ulong_t)&penwell_pci_platdata,
> >>+	},
> >
> >Can this go into 3.12-final, and any other stable kernel releases as
> >well?  Or does this platform also need other fixes that aren't in 3.10
> >and 3.11?
> 
> This was tested on 3.10+
> It might work on 3.4 but it's not validated. I can test it if we
> care about chipidea on 3.4.

I doubt anyone cares about chipidea on 3.4, 3.10 is good enough.  I've
mushed these patches together into one to make it easier to backport and
apply to Linus's tree for 3.12-final.

thanks,

greg k-h
