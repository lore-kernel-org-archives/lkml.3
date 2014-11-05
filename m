Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaKEU1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:27:40 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39448 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaKEU1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:27:36 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Joerg Roedel <joro@8bytes.org>, Simon Xue <xxm@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 3/3] ARM: dts: rk3288: add VOP iommu nodes
Date: Wed, 05 Nov 2014 21:30:30 +0100
Message-ID: <1838591.iyIlAuCyiq@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1414983209-2472-4-git-send-email-djkurtz@chromium.org>
References: <1414983209-2472-1-git-send-email-djkurtz@chromium.org> <1414983209-2472-4-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 3. November 2014, 10:53:29 schrieb Daniel Kurtz:
> Add device nodes for the VOP iommus.
> Device nodes for other iommus will be added in later patches.
> 
> The iommu nodes use the #iommu-cells property as described in:
>   Documentation/devicetree/bindings/iommu/iommu.txt
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Simon Xue <xxm@rock-chips.com>

I've applied this patch to my dts branch for 3.19
