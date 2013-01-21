Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3AUI4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:56:10 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5574 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3AUI4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:56:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Jan 2013 00:54:42 -0800
Message-ID: <50FD0299.2090408@nvidia.com>
Date: Mon, 21 Jan 2013 16:55:53 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: Mark Zhang <nvmarkzhang@gmail.com>, Alex Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 2/3] tegra: pwm-backlight: add tegra pwm-bl driver
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com> <1358591420-7790-3-git-send-email-acourbot@nvidia.com> <50FCEFDE.8000705@gmail.com> <2440319.UsvGAcXXBp@fb07-iapwap2>
In-Reply-To: <2440319.UsvGAcXXBp@fb07-iapwap2>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 04:52 PM, Marc Dietrich wrote:
> Hi,
> 
>>> diff --git a/drivers/video/backlight/pwm_bl_tegra.c
>>> b/drivers/video/backlight/pwm_bl_tegra.c new file mode 100644
>>> index 0000000..8f2195b
>>> --- /dev/null
>>> +++ b/drivers/video/backlight/pwm_bl_tegra.c
>>
>> So according to the filename, I think we can put all tegra boards codes
>> here, right? Just like what you do for Ventana, if I wanna add support
>> for cardhu, I can define similar functions -- let's say "init_cardhu",
>> "exit_cardhu", "notify_cardhu" and "notify_after_cardhu", right?
>>
>> But I think if we do in this way, the file will become very long soon.
>> And there are a lot of redundant codes in it. So do you have any
>> suggestions?
> 
> I think we (for PAZ00) will just reuse the ventana code which is sufficient 
> for us. But adding "pwm-backlight-ventana" to our DTS may look a bit strange. 
> On the other hand, I guess that's why the property is called "compatible".
> 

Ah, yeah, that looks strange. :)
Okay, so I know why Alex wants to use panel name while not board name...

> Marc
> 
