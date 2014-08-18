Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaHRSsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:48:41 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:58962 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaHRSsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:48:38 -0400
Message-ID: <53F24A80.4000607@gmail.com>
Date: Mon, 18 Aug 2014 20:48:32 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
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
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>	<1406868897-26874-2-git-send-email-afaerber@suse.de> <CAD=FV=VBa5rs_woj0mshFFbA69Nhyi3hXK_XX7-54T3vFyKYHA@mail.gmail.com> <53F247E2.2070007@samsung.com>
In-Reply-To: <53F247E2.2070007@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 18.08.2014 20:37, Kukjin Kim wrote:
> On 08/01/14 11:26, Doug Anderson wrote:
>> Hi,
>>
> Hi,
> 
>> On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber<afaerber@suse.de>  wrote:
>>> The pinctrl properties should be on the device directly and not on the
>>> slot sub-node.
>>>
>>> Reported-by: Doug Anderson<dianders@chromium.org>
>>> Cc: Jaehoon Chung<jh80.chung@samsung.com>
>>> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>>> Signed-off-by: Andreas Färber<afaerber@suse.de>
>>
>> Let's land this one before Jaehoon's, since it was a hidden
>> functionality change in his patch.  It will be an easy conflict to
>> resolve when his patch is applied.
>>
> Sounds good to me, I've applied this before Jaehoon's change.
> 
>> Reviewed-by: Doug Anderson<dianders@chromium.org>

Version 6 of this series has been already posted. However this
particular patch has not changed, so it's fine.

Best regards,
Tomasz
