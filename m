Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaIHQ3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:29:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40556 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbaIHQ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:29:30 -0400
Message-ID: <540DD950.30207@ti.com>
Date: Mon, 8 Sep 2014 11:29:04 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 00/10] ARM: OMAP5 / DRA7: Add framework for suspend and
 cpuidle
References: <1408716154-26101-1-git-send-email-nm@ti.com> <7htx4xbv7p.fsf@paris.lan>
In-Reply-To: <7htx4xbv7p.fsf@paris.lan>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 02:15 PM, Kevin Hilman wrote:
> Nishanth Menon <nm@ti.com> writes:
> 
>> The following series are various fixes and improvements for
>> supporting suspend-to-ram. This depends on the following for basic functionality:
>> series 1/6 where powerdomain fixes were involved.
> 
> I had a look through this series, and it looks good overall.  I think Daniel
> needs to weigh in on the CPUidle driver, otherwise.
> 
> Reviewed-by: Kevin Hilman <khilman@linaro.org>
> 
> I also tested on omap5uevm with the pm_debug/wakeup_timer_seconds patch.
> 
> Tested-by: Kevin Hilman <khilman@linaro.org>
> 
> Kevin
> 

I am dropping cpuidle patch for the moment, and sending remaining
stuff to Tony for merge with Kevin's Reviewed and Tested. we will send
cpuidle once we have Daniel's response.

-- 
Regards,
Nishanth Menon
