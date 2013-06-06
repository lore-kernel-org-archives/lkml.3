Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3FFPCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:02:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43988 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3FFPCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:02:10 -0400
Message-ID: <51B0A390.1030807@ti.com>
Date: Thu, 6 Jun 2013 17:58:24 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c: omap: convert to module_platform_driver()
References: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com> <1366723151-23209-2-git-send-email-grygorii.strashko@ti.com> <87fvwylxl8.fsf@linaro.org> <51ADD06B.3000201@ti.com> <87zjv5zq41.fsf@linaro.org> <51AF20F0.30000@ti.com> <20130605135048.GB2934@katana>
In-Reply-To: <20130605135048.GB2934@katana>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 04:50 PM, Wolfram Sang wrote:
>> The similar patch already exists:
>> https://patchwork.kernel.org/patch/2448251/ - [v2,1/2] RTC: rtc-twl:
>> Fix rtc_reg_map initialization
>> from Peter Ujfalusi
> So, I think it is best if you resend this patch after all the fixes it
> needs are applied or you resend the series with all patches it depends
> on. Which should then probably go via arm-soc. Or?
>
It can wait - I'll track and resend after twl-rtc patches.

-grygorii

