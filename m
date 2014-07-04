Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaGDJGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:06:16 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62014 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaGDJGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:06:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Olav Haugan <ohaugan@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Allen Martin <amartin@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 02/10] devicetree: Add generic IOMMU device tree bindings
Date: Fri, 04 Jul 2014 11:05:01 +0200
Message-ID: <9506037.pCJq3zRKJU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <9ffe3c3871ef4b60a955259bfa0bed6c@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com> <1403815790-8548-3-git-send-email-thierry.reding@gmail.com> <9ffe3c3871ef4b60a955259bfa0bed6c@BL2PR03MB468.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8CR1kfRuDyEchq7L2uySjSXYC1grhwK0E7PuqekAvHR
 Q44tW0Ym6+ng2GqMWKjCKz63rNFHQKMOg04qCCKJcXwovrL//7
 8bd6KdO8mnBx0mrP6nAhimpS/KP8oGJA2OkRpT2XNEYPXXZozs
 qNL2Jh+J+Av2TQLccLoDjFe1lsiSNBArEi3VrVq5GNe5M1/8LU
 F9ARfeiJkD2bL7UjflwAixH0WC7idXFClqOvxJ6VITg/D2En/d
 L08rP7SimRPhpiTKOE7b904S52H37wbAGi6bGEAJurpli/J01O
 Lc6DgabV5+lZZFSRHAy/gT00GC1SQW69eqgFBzJMxffy5/vYMd
 m5UUlH3+s+JO2IDgxpw4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2014 06:42:48 Varun Sethi wrote:
> Master node corresponds to the device node, right? Master ID would correspond
> to Stream ID? We are already using "iommu-parent" property to link a device
> to its corresponding IOMMU. We can use the same property instead of using "iommus".

I don't see "iommu-parent" used anywhere, just "fsl,iommu-parent". We can
probably allow "fsl,iommu-parent" as an alias for "iommus" for backwards-
compatibility if that helps you on PowerPC. For ARM, I'd prefer to mandate
that we use just "iommus".

	Arnd
