Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbaIRG55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 02:57:57 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40683 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaIRG5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 02:57:55 -0400
Message-ID: <541A8051.20207@collabora.co.uk>
Date: Thu, 18 Sep 2014 08:48:49 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Daniel Drake <drake@endlessm.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Subject: Re: [PATCH 2/2] ARM: dts: Add rtc_src clk for s3c-rtc on exynos5250-snow
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk>	<1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=W7xJ01m2oLtuDnogOmrpwpztbir=59oSWU6oojFYUWKw@mail.gmail.com>
In-Reply-To: <CAD=FV=W7xJ01m2oLtuDnogOmrpwpztbir=59oSWU6oojFYUWKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug, Andreas,

On 09/17/2014 05:47 PM, Doug Anderson wrote:
>>
>>         rtc@101E0000 {
>>                 status = "okay";
>> +               clocks = <&clock CLK_RTC>, <&max77686 MAX77686_CLK_AP>;
>> +               clock-names = "rtc", "rtc_src";
> 
> Wait, seriously?  Snow is still using the "rtc@101E0000" syntax?
> Whatever happened to the series that Andreas worked so hard on,
> including <https://patchwork.kernel.org/patch/4664801/>?
>

Andreas, I completely forgot about your series when writing this patch even
though I've on my TO-DO to sync the downstream and upstream Snow DTS once your
patches land. Sorry about that.

> 
> In any case, there's nothing wrong with Javier's patch other than the
> fact that it will eventually need to get merged with Andreas's, so:
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> 

Thanks, I'll re-spin and post again once Kukjin merges Andreas series.

Best regards,
Javier
