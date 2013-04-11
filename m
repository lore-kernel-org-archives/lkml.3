Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3DKVsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:48:08 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64331 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3DKVsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:48:06 -0400
X-IronPort-AV: E=Sophos;i="4.87,458,1363158000"; 
   d="scan'208";a="37861097"
Message-ID: <51672F93.7080109@codeaurora.org>
Date: Thu, 11 Apr 2013 14:48:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH 1/4] Documentation: Add memory mapped ARM architected
 timer binding
References: <1365474623-29181-1-git-send-email-sboyd@codeaurora.org> <1365474623-29181-2-git-send-email-sboyd@codeaurora.org> <20130409090843.GS23725@e106331-lin.cambridge.arm.com> <516444FE.2080200@codeaurora.org> <20130410101336.GB8799@e106331-lin.cambridge.arm.com> <51662584.6070906@codeaurora.org> <20130411112407.GD8259@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130411112407.GD8259@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/13 04:24, Mark Rutland wrote:
> Could we say the reg for the second view is optional?
>

Yes, that's already covered in the binding.

> Might we have a hardware / firmware configuration where the kernel can only access
> the secondary view?
>

I don't see how this is possible. The CNTACRn register controls secure
vs. non-secure access for particular registers in a frame regardless of
which view is used. The CNTPL0ACRn is not a security restricted register
and it can only restrict access to certain registers in the second view.
No combination of settings in these registers can restrict access to
only the second view in a frame with two views.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

