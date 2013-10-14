Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3JNQFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:05:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54569 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab3JNQFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:05:05 -0400
Message-ID: <525C15E8.9010201@zytor.com>
Date: Mon, 14 Oct 2013 09:03:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v3 07/10] intel_mid: Added custom device_handler support
References: <1381549404-22594-1-git-send-email-david.a.cohen@linux.intel.com> <1381549404-22594-8-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1381549404-22594-8-git-send-email-david.a.cohen@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 08:43 PM, David Cohen wrote:
>  
>  	/* MSIC subdevices */
> -	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data},
> -	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data},
> -	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data},
> -	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data},
> -	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data},
> -	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data},
> -
> +	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data,
> +					NULL},
> +	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data, NULL},
> +	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data, NULL},
> +	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data,
> +					NULL},
> +	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data, NULL},
> +	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data,
> +					NULL},
>  	{},
>  };
>  

For highly regular arrays like this it is better to keep each line a
single line even if it gets a bit too long rather than randomly breaking
them.  The alternative is to put every field of every entry on a
separate line, but I don't think that is necessary called for here.

	-hpa


