Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaHRUNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 16:13:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaHRUNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 16:13:45 -0400
Message-ID: <53F25E72.4080205@suse.de>
Date: Mon, 18 Aug 2014 22:13:38 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>, Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 01/10] ARM: dts: Fix MMC pinctrl for exynos5250-snow
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>	<1406868897-26874-2-git-send-email-afaerber@suse.de> <CAD=FV=VBa5rs_woj0mshFFbA69Nhyi3hXK_XX7-54T3vFyKYHA@mail.gmail.com> <53F247E2.2070007@samsung.com> <53F24A80.4000607@gmail.com> <53F25C25.4070602@samsung.com>
In-Reply-To: <53F25C25.4070602@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 18.08.2014 22:03, schrieb Kukjin Kim:
> On 08/18/14 13:48, Tomasz Figa wrote:
>> On 18.08.2014 20:37, Kukjin Kim wrote:
>>> On 08/01/14 11:26, Doug Anderson wrote:
>>>> On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber<afaerber@suse.de>  
>>>> wrote:
>>>>> The pinctrl properties should be on the device directly and not on the
>>>>> slot sub-node.
>>>>>
>>>>> Reported-by: Doug Anderson<dianders@chromium.org>
>>>>> Cc: Jaehoon Chung<jh80.chung@samsung.com>
>>>>> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>>>>> Signed-off-by: Andreas Färber<afaerber@suse.de>
>>>>
>>>> Let's land this one before Jaehoon's, since it was a hidden
>>>> functionality change in his patch.  It will be an easy conflict to
>>>> resolve when his patch is applied.
>>>>
>>> Sounds good to me, I've applied this before Jaehoon's change.
>>>
>>>> Reviewed-by: Doug Anderson<dianders@chromium.org>
>>
>> Version 6 of this series has been already posted. However this
>> particular patch has not changed, so it's fine.
>>
> Oh, got it. Hope this and 2nd should be same with version 6 ;)

It is documented as such. :) Others did have changes, of course.

I've started looking into rebasing myself: beware that the smdk5250
cleanup has an additional conflict in the spi node (cs-gpios movement).

http://git.kernel.org/cgit/linux/kernel/git/kgene/linux-samsung.git/commit/arch/arm/boot/dts/exynos5250-smdk5250.dts?h=v3.18-next/dt-samsung&id=e138d4333aa02a3daa12c04192bc5c842bffee74

Thanks,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
