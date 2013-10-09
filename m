Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3JIXcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:32:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35278 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab3JIXcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:32:10 -0400
Message-ID: <5255E760.8010104@ti.com>
Date: Wed, 9 Oct 2013 18:31:44 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Kevin Hilman <khilman@linaro.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH V6 00/15] ARM: OMAP3+: support cpufreq-cpu0 for device
 tree boot
References: <1381354144-7134-1-git-send-email-nm@ti.com>
In-Reply-To: <1381354144-7134-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 04:28 PM, Nishanth Menon wrote:
> Hi,
> 
> The series is based on Tero's V8 of patches[1] - enables the use of
> cpufreq-cpu0 generic driver for all OMAP and related derivatives.
> 
> I will stop copy pasting the series complete history and point at [2].
> 
> Main changes since V5:
> - no more clock driver as part of this series[3] - instead depend on clock
>   conversion[1].
> - added DRA7/OMAP5
> 

I am having all kind of problems with my git mail setup atm -
apologies if any patches have arrived twice/in weird sequence :(


-- 
Regards,
Nishanth Menon
