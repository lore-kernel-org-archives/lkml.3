Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaLJLcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:32:11 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:63877 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbaLJLcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:32:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ray Jui <rjui@broadcom.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        hauke@hauke-m.de
Subject: Re: [PATCH 2/4] PCI: iproc: Add Broadcom iProc PCIe driver
Date: Wed, 10 Dec 2014 12:31:38 +0100
Message-ID: <9707535.Y78sV0TgX4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418169871-19232-3-git-send-email-rjui@broadcom.com>
References: <1418169871-19232-3-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:i05wScWZ/qLMqphkefZ9GCsAiiFKsw86TUH7Yg0ekYDSGcYQHYc
 y9FUjm10HWxDugXrkUzD1fXaH6wGDANm/2ekGcDT5Wz8jgpYSpHGRyb7IPFlM/Ios8JseA8
 H/SmQ9/v3BL1NfwaGUYkFE40bOzG/6Nrrzyj61I23xHHS6uZ3pz7HMJISKbWcoE3tKNePqR
 BIaxCgpIrWh9WI0+GJU1g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2014 16:04:29 Ray Jui wrote:
> Add initial version of the Broadcom iProc PCIe driver. This driver
> has been tested on NSP and Cygnus and is expected to work on all iProc
> family of SoCs that deploys the same PCIe host controller
> 
> The driver also supports MSI
> 
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: Scott Branden <sbranden@broadcom.com>

The driver looks suspiciously like the one that Hauke already submitted a
while ago for bcm53xx. Please come up with a merged driver that works for
both.

Are you sure that iProc isn't based on the BCMA bus infrastructure after
all? Even the physical address of your PCI host falls into the address
range that is used for the internal BCMA bus on the other chips!

	Arnd
