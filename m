Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbaGNUGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:06:23 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34608 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975AbaGNUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:06:16 -0400
Date: Mon, 14 Jul 2014 13:06:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, clemens@ladisch.de, jdelvare@suse.de,
        rdunlap@infradead.org, bhelgaas@google.com, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] hwmon, k10temp: Add support for AMD F15h M60h processor
Message-ID: <20140714200612.GA29123@roeck-us.net>
References: <1405369388-12729-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140714195128.GA25124@pd.tnic>
 <53C4368E.9090103@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C4368E.9090103@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 02:59:10PM -0500, Aravind Gopalakrishnan wrote:
> On 7/14/2014 2:51 PM, Borislav Petkov wrote:
> >On Mon, Jul 14, 2014 at 03:23:08PM -0500, Aravind Gopalakrishnan wrote:
> >>@@ -211,6 +228,7 @@ static const struct pci_device_id k10temp_id_table[] = {
> >>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
> >>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
> >>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
> >>+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F3) },
> >>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
> >>  	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
> >>  	{}
> >>diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> >>index 7fa3173..3c8e328 100644
> >>--- a/include/linux/pci_ids.h
> >>+++ b/include/linux/pci_ids.h
> >>@@ -520,6 +520,7 @@
> >>  #define PCI_DEVICE_ID_AMD_15H_M10H_F3	0x1403
> >>  #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F3 0x141d
> >>  #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F4 0x141e
> >>+#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F3 0x1573
> >I'm assuming this is used somewhere else besides k10temp.c?
> >
> 
> Yeah, will most likely need to add EDAC bits. But that is something
> I can't test now.
> 
Sorry, I can not add this to a common file unless it is used elsewhere.
I would suggest to add it locally for now. It can be moved to the
common file once it is used elsewhere.

Guenter
