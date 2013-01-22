Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3AVQaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:30:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41299 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3AVQaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:30:07 -0500
Message-ID: <50FEBE8B.60101@wwwdotorg.org>
Date: Tue, 22 Jan 2013 09:30:03 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Zhang <markz@nvidia.com>, "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 2/3] tegra: pwm-backlight: add tegra pwm-bl driver
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com> <1358591420-7790-3-git-send-email-acourbot@nvidia.com> <50FD7EF9.1010205@wwwdotorg.org> <12033649.LY58cllSHv@percival>
In-Reply-To: <12033649.LY58cllSHv@percival>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 08:24 PM, Alex Courbot wrote:
> On Tuesday 22 January 2013 01:46:33 Stephen Warren wrote:
>>>  arch/arm/boot/dts/tegra20-ventana.dts  |  18 +++-
>>>  arch/arm/configs/tegra_defconfig       |   1 +
>>>  drivers/video/backlight/Kconfig        |   7 ++
>>>  drivers/video/backlight/pwm_bl.c       |   3 +
>>>  drivers/video/backlight/pwm_bl_tegra.c | 159

>>> +static struct pwm_backlight_subdriver pwm_backlight_ventana_subdriver = {
>>> +	.name = "pwm-backlight-ventana",
>>> +	.init = init_ventana,
>>> +	.exit = exit_ventana,
>>> +	.notify = notify_ventana,
>>> +	.notify_after = notify_after_ventana,
>>> +};
>>
>> It seems like all of that code should be completely generic.
> 
> Sorry, I don't get your point here - could you elaborate?

Nothing there (i.e. in the body of any of those functions) seems
remotely specific to Ventana or even Ventana's panel; presumably it
would work for any built-in LCD panel?
