Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3JCUNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:13:22 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63453 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3JCUNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:13:19 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Benoit Cousson <bcousson@baylibre.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH V5 0/6] ARM: OMAP3+: support cpufreq-cpu0 for device tree boot
References: <1368039976-29648-1-git-send-email-nm@ti.com>
	<87pprmuwxg.fsf@linaro.org> <524DA41C.7000809@ti.com>
Date: Thu, 03 Oct 2013 13:13:15 -0700
In-Reply-To: <524DA41C.7000809@ti.com> (Nishanth Menon's message of "Thu, 3
	Oct 2013 12:06:36 -0500")
Message-ID: <87d2nmun8k.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> fixing Benoit's mail ID.
> On 10/03/2013 11:43 AM, Kevin Hilman wrote:
>> Hi Nishanth,
>> 
>> Nishanth Menon <nm@ti.com> writes:
>> 
>>> The following version 5 of the series arose from trying to use
>>> BeagleBoard-XM (OMAP3 variant) for doing CPU DVFS using cpufreq-cpu0.
>>> This series enables the generic cpufreq-cpu0 driver to be used in
>>> device tree enabled boot while maintaining support of the legacy
>>> omap-cpufreq driver when used in non device tree enabled boot.
>> 
>> What's the status of this series?  Is it still waiting on the clock DT
>> changes?
>
> yes - i do have a new series lined up at the moment here[1] - trying
> to ensure everything is dandy before public post. ofcourse, we'd like
> to ensure we have feedback on tero's series[2]. I am now working on
> ensuring ABB regulator[3](again depends on Tero's series) fits on top
> of Mike's voltage notifier series[4]
>
> So, yep, everything is blocked due to lack of feedback on Tero's
> series [2].

OK, thanks for the update. 

Kevin
