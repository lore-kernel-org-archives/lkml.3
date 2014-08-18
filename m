Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaHRUDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 16:03:41 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35490 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaHRUDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 16:03:39 -0400
Message-ID: <53F25C05.5070604@samsung.com>
Date: Mon, 18 Aug 2014 15:03:17 -0500
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 02/10] ARM: dts: Fold exynos5250-cros-common into exynos5250-snow
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>	<1406868897-26874-3-git-send-email-afaerber@suse.de> <CAD=FV=USKuOxiFo=VgEB6aAQ=LdLv-7+jXQNh4VCMBQwasygxg@mail.gmail.com>
In-Reply-To: <CAD=FV=USKuOxiFo=VgEB6aAQ=LdLv-7+jXQNh4VCMBQwasygxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 11:45, Doug Anderson wrote:
> Andreas,
>
> On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber<afaerber@suse.de>  wrote:
>> exynos5250-cros-common.dtsi was meant for sharing common pieces across
>> ChromeOS devices. This turned out premature, as several devices ended up
>> in the common file that are not common after all. Since the remaining
>> common ChromeOS pieces are fairly minor,  exynos5250-cros-common.dtsi
>> was requested to be merged into the Snow device tree, sharing only the
>> keyboard controller for now. This may be re-evaluated as both mature.
>>
>> Suggested-by: Doug Anderson<dianders@chromium.org>
>> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>> Signed-off-by: Andreas Färber<afaerber@suse.de>
>> ---
>>   v4 ->  v5:
>>   * Extended commit message (Tomasz Figa)
>>
>>   v3 ->  v4: Unchanged
>>
>>   v2 ->  v3:
>>   * Renamed subject to match Kukjin's style
>>   * Rebased onto MMC pinctrl bug fix (Doug Anderson)
>>
>>   v2: New (Doug Anderson)
>>
>>   arch/arm/boot/dts/exynos5250-cros-common.dtsi | 164 --------------------------
>>   arch/arm/boot/dts/exynos5250-snow.dts         | 164 +++++++++++++++++++++++---
>>   2 files changed, 145 insertions(+), 183 deletions(-)
>
> Reviewed-by: Doug Anderson<dianders@chromium.org>
>
> I'd suggest that this land sooner rather than later to avoid future conflicts.

Applied, thanks.

- Kukjin
