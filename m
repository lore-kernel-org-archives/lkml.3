Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639Ab3BYUHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:07:39 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36251 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759584Ab3BYUHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:07:37 -0500
Message-ID: <1361822854.2724.1.camel@joe-AO722>
Subject: Re: [PATCH 3/4] block: IBM RamSan 70/80 branding changes.
From: Joe Perches <joe@perches.com>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com
Date: Mon, 25 Feb 2013 12:07:34 -0800
In-Reply-To: <20130225185815.GA7974@oc6784271780.ibm.com>
References: <20130225185815.GA7974@oc6784271780.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-25 at 12:58 -0600, Philip J. Kelleher wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> This patch includes changing the hardware branding name from
> IBM RamSan to IBM FlashSystem.

just a trivial comment

> diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
[]
> @@ -45,16 +45,14 @@
>  
>  struct proc_cmd;
>  
> -#define PCI_VENDOR_ID_TMS_IBM		0x15B6
> -#define PCI_DEVICE_ID_RS70_FLASH	0x0019
> -#define PCI_DEVICE_ID_RS70D_FLASH	0x001A
> -#define PCI_DEVICE_ID_RS80_FLASH	0x001C
> -#define PCI_DEVICE_ID_RS81_FLASH	0x001E
> +#define PCI_VENDOR_ID_IBM		0x1014

PCI_VENDOR_ID_IBM is already #defined in pci_ids.h


