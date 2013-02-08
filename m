Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946016Ab3BHGrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:47:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54560 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab3BHGrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:47:46 -0500
Message-ID: <51149FC8.50902@ti.com>
Date: Fri, 8 Feb 2013 12:18:40 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [PATCHv3 4/4] arm: Add generic timer broadcast support
References: <1358183124-28461-1-git-send-email-mark.rutland@arm.com> <1358183124-28461-5-git-send-email-mark.rutland@arm.com> <5112C25F.6000508@wwwdotorg.org> <20130207100403.GD16987@e106331-lin.cambridge.arm.com> <511392A8.9010905@ti.com> <5113DBAF.2050104@wwwdotorg.org>
In-Reply-To: <5113DBAF.2050104@wwwdotorg.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013 10:21 PM, Stephen Warren wrote:
> On 02/07/2013 04:40 AM, Santosh Shilimkar wrote:
[...]

>> Stephan,
>>
>> Do we have crash log seen on Tegra ? Which tegra CPUIDLE driver
>> is being used when crash is seen ?
>
> The crash log is below. It's simply because td->evt->broadcast is NULL
> because it wasn't ever set.
>
Thanks for the log. Its clear from the log that broadcast event wasn't
set.

Regards,
Santosh
