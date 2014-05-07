Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbaEGMLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:11:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54256 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaEGMLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:11:06 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <536A22D2.5070104@roeck-us.net>
Date: Wed, 07 May 2014 05:10:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] coretemp.0 folder contents changed
References: <5367C6A7.5020008@linux.intel.com>	<20140505173231.GA25644@roeck-us.net>	<20140506135558.3cafd062@endymion.delvare>	<5368E45F.30301@roeck-us.net> <20140507091308.227d8152@endymion.delvare>
In-Reply-To: <20140507091308.227d8152@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 12:13 AM, Jean Delvare wrote:
> Hi Guenter,
>
> On Tue, 06 May 2014 06:32:15 -0700, Guenter Roeck wrote:
>> Can we implement a similar approach to network devices and make hwmon
>> path names (ie the /sys/class/hwmon/XXX path name) configurable via udev ?
>> Might be worth exploring.
>
> This is one possibility indeed. The good thing is that libsensors makes
> no assumption on hwmon class device names, so we can change the names
> without breaking any application which uses libsensors. Scripts
> accessing sysfs directly may break though (pwmconfig would, for
> example.)
>
> We'll have to be careful when choosing the new names, and make sure
> there is no name space collision. Network interface renaming has caused
> a great deal of trouble out there.
>
Agreed. I'll try to find some time to play with it.

> Another approach, which I have in mind for quite some time already but
> could never find the time to implement, would be a small helper binary
> which would look-up hwmon devices by libsensors-like name (and the
> other way around too.) Scripts could use it to benefit from libsensors
> persistent names.
>
Still needs that binary, though.

Guenter

