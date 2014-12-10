Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbaLJQrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:47:09 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:28287 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128AbaLJQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:47:07 -0500
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="52573029"
Message-ID: <54887901.8070501@broadcom.com>
Date: Wed, 10 Dec 2014 08:46:57 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Ray Jui <rjui@broadcom.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        <hauke@hauke-m.de>
Subject: Re: [PATCH 2/4] PCI: iproc: Add Broadcom iProc PCIe driver
References: <1418169871-19232-3-git-send-email-rjui@broadcom.com> <9707535.Y78sV0TgX4@wuerfel>
In-Reply-To: <9707535.Y78sV0TgX4@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-12-10 03:31 AM, Arnd Bergmann wrote:
> On Tuesday 09 December 2014 16:04:29 Ray Jui wrote:
>> Add initial version of the Broadcom iProc PCIe driver. This driver
>> has been tested on NSP and Cygnus and is expected to work on all iProc
>> family of SoCs that deploys the same PCIe host controller
>>
>> The driver also supports MSI
>>
>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>
> The driver looks suspiciously like the one that Hauke already submitted a
> while ago for bcm53xx. Please come up with a merged driver that works for
> both.
Could you please be a little more specific.  What driver did "Hauke 
already submitted"?  I do not see any driver in the kernel you are 
talking about.
>
> Are you sure that iProc isn't based on the BCMA bus infrastructure after
> all? Even the physical address of your PCI host falls into the address
> range that is used for the internal BCMA bus on the other chips!
BCMA seems to be for MIPS architectures.  It seems to be quite specific 
to those architectures using BCMA.  I see no use of it in bcm53xx code?
>
> 	Arnd
>

