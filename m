Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab3BHGvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:51:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60424 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3BHGva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:51:30 -0500
Message-ID: <5114A0B0.2030103@ti.com>
Date: Fri, 8 Feb 2013 12:22:32 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [PATCHv3 4/4] arm: Add generic timer broadcast support
References: <1358183124-28461-1-git-send-email-mark.rutland@arm.com> <1358183124-28461-5-git-send-email-mark.rutland@arm.com> <5112C25F.6000508@wwwdotorg.org> <20130207100403.GD16987@e106331-lin.cambridge.arm.com> <511392A8.9010905@ti.com> <20130207171748.GB28072@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130207171748.GB28072@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Thursday 07 February 2013 10:47 PM, Mark Rutland wrote:

[..]

>>> I believe the patch below will fix this for Tegra and any other platforms where
>>> broadcast is required in low power states.
>>>
 From the Stephan's crash the issue is pretty clear and your patch make
sense. Some how I didn't manage to reproduce the issue on my board and
hence assumed everything is just fine. Will have a look at it later why
it didn't explode since it was so obvious.

Sorry for the noise.

Regards
Santosh


