Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab3IZKhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:37:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58463 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3IZKhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:37:14 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52440E54.5080401@roeck-us.net>
Date: Thu, 26 Sep 2013 03:37:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i2c-dev: Create 'name' attribute automatically
References: <1377966619-20197-1-git-send-email-linux@roeck-us.net> <20130925202035.GB4290@katana> <20130925211104.GA2784@roeck-us.net> <20130926082835.GA3057@katana>
In-Reply-To: <20130926082835.GA3057@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 01:28 AM, Wolfram Sang wrote:
> Hi,
>
>>> What race condition?
>>>
>>
>> Userspace trying to access the name attribute before it is created.
>> See http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/
>
> Thanks!
>
>>> Have you tried this with two instances? I don't think it will work since
>>> class_register modifies the class struct.
>>>
>> Half a dozen instances, actually. Unless I am missing something, seems to be
>
> My bad. Sorry for the noise.
>
>> Anyway, the patch is obsolete; one is supposed to use class->dev_groups now.
>
> Are you willing to update the patch?
>

Sure. Give me a couple of days.

Thanks,
Guenter


