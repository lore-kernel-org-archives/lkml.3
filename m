Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015Ab3CEBQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:16:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34358 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758952Ab3CEBQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:16:20 -0500
Date: Tue, 5 Mar 2013 09:16:13 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v2] video: Add Hyper-V Synthetic Video Frame Buffer Driver
Message-ID: <20130305011613.GA21499@kroah.com>
References: <1362434172-25070-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362434172-25070-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 01:56:12PM -0800, Haiyang Zhang wrote:
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2951,3 +2951,6 @@
>  #define PCI_DEVICE_ID_XEN_PLATFORM	0x0001
>  
>  #define PCI_VENDOR_ID_OCZ		0x1b85
> +
> +#define PCI_VENDOR_ID_MICROSOFT		0x1414
> +#define PCI_DEVICE_ID_HYPERV_VIDEO	0x5353

Please see the top of this while for why you shouldn't be adding any
lines to this file.

greg k-h
