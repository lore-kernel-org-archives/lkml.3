Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3GJPVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:21:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:23834 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3GJPVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:21:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1036,1363158000"; 
   d="scan'208";a="367854294"
Message-ID: <51DD7D78.2020506@linux.intel.com>
Date: Wed, 10 Jul 2013 08:27:52 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 0/4] iio: hid-sensor: add module alias for autoload
References: <1373445120-5407-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1373445120-5407-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There was no intention to prevent auto loading. Did you get chance to 
test these changes?

Thanks,
Srinivas

On 07/10/2013 01:31 AM, Alexander Holler wrote:
> Hello,
>
> I'm not sure if it was by intention that none of the hid-sensor drivers
> were loaded automatically. But I assume it was not by intention.
>
> Therefor I've added a module alias to every hid-sensor driver by adding
> a MODULE_DEVICE_TABLE.
>
> This has another benefit: it makes it possible to use a normale driver name.
>
> Therefor I've changed all driver names to KBUILD_MODNAME instead of
> HID-SENSOR-2000xx as the later isn't very descriptive when starring at
> kernel messages.
>
> Regards,
>
> Alexander Holler
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

