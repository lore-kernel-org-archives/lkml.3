Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab3B0Roa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:44:30 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58309 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab3B0Ro2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:44:28 -0500
X-IronPort-AV: E=Sophos;i="4.84,749,1355126400"; 
   d="scan'208";a="27056857"
Message-ID: <512E45FB.90204@codeaurora.org>
Date: Wed, 27 Feb 2013 09:44:27 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Will Deacon <will.deacon@arm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: vfp: fix fpsid register subarchitecture field mask
 width
References: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org> <20130222182705.GC19527@mudshark.cambridge.arm.com> <5128034A.4000008@codeaurora.org> <20130225111835.GA24254@mudshark.cambridge.arm.com> <512C2577.3030202@codeaurora.org> <20130226175439.GT17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130226175439.GT17833@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/13 09:54, Russell King - ARM Linux wrote:
> What I actually need from you is: for the Qualcomm implementation, what
> are the subarch bits defined as, and what do they correspond with - both
> the VFP version, and whether they correspond with any ARM common VFP
> subarchitecture version.

For the Qualcomm implementation, the subarch bits have always been 0x40
so far. And they are compatible with "VFPv3 architecture or later with
common VFP subarchitecture v3". In your table below it would be the last
row.

>
> In ARM land, these are the possiblities - I've also listed those
> platforms which I definitely know of at the moment which use the
> particular version combination:
>
> VFP version	VFP subarch
> V1		-
> V2		V1		Raspberry Pi
> V3		V2		Marvell Dove (Cubox) (though, not ARM)
> V3		NULL		OMAP3430 / OMAP4430
> V3		V3

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

