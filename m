Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab3JCRHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:07:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49994 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab3JCRHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:07:07 -0400
Message-ID: <524DA41C.7000809@ti.com>
Date: Thu, 3 Oct 2013 12:06:36 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Mike Turquette <mturquette@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH V5 0/6] ARM: OMAP3+: support cpufreq-cpu0 for device tree
 boot
References: <1368039976-29648-1-git-send-email-nm@ti.com> <87pprmuwxg.fsf@linaro.org>
In-Reply-To: <87pprmuwxg.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixing Benoit's mail ID.
On 10/03/2013 11:43 AM, Kevin Hilman wrote:
> Hi Nishanth,
> 
> Nishanth Menon <nm@ti.com> writes:
> 
>> The following version 5 of the series arose from trying to use
>> BeagleBoard-XM (OMAP3 variant) for doing CPU DVFS using cpufreq-cpu0.
>> This series enables the generic cpufreq-cpu0 driver to be used in
>> device tree enabled boot while maintaining support of the legacy
>> omap-cpufreq driver when used in non device tree enabled boot.
> 
> What's the status of this series?  Is it still waiting on the clock DT
> changes?

yes - i do have a new series lined up at the moment here[1] - trying
to ensure everything is dandy before public post. ofcourse, we'd like
to ensure we have feedback on tero's series[2]. I am now working on
ensuring ABB regulator[3](again depends on Tero's series) fits on top
of Mike's voltage notifier series[4]

So, yep, everything is blocked due to lack of feedback on Tero's
series [2].

[1]
https://github.com/nmenon/linux-2.6-playground/commits/devel/cpufreq-cpu0
[2] http://marc.info/?t=138009899400001&r=1&w=2
[3]
https://github.com/nmenon/linux-2.6-playground/commits/push/abb-regulator-dts
[4]
http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=shortlog;h=refs/heads/clk-next-volt
-- 
Regards,
Nishanth Menon
