Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaJJP3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 11:29:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50537 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbaJJP3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 11:29:34 -0400
Message-ID: <5437FB3F.4010906@ti.com>
Date: Fri, 10 Oct 2014 11:29:03 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: keystone: add bus notifier to set dma_pfn_offset
 for pci devices
References: <1412954137-4567-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1412954137-4567-1-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/10/14 11:15 AM, Murali Karicheri wrote:
> When PCI device driver such as that for e1000e tries to set dma mask
> using dma_set_mask_and_coherent(), it fails because the dma_pfn_offset
> is incorrect on a Keystone SoC. This patch fix this by adding a bus
> notifier to set this correctly for PCI devices.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
Looks good. I will pick this up after the merge window.
Please send this patch along with PCI dts patches
together once the rc1 is tagged.

Regards,
Santosh


