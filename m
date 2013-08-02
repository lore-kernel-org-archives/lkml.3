Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3HBQju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:39:50 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58223 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab3HBQjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:39:48 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <51FBE0D5.3070007@roeck-us.net>
Date: Fri, 02 Aug 2013 09:39:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>, "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7] watchdog: Add MOXA ART watchdog driver
References: <1375098093-8975-1-git-send-email-jonas.jensen@gmail.com> <1375101228-10930-1-git-send-email-jonas.jensen@gmail.com> <20130802114159.GK2884@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130802114159.GK2884@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 04:41 AM, Mark Rutland wrote:
> On Mon, Jul 29, 2013 at 01:33:48PM +0100, Jonas Jensen wrote:
>> Add watchdog driver for MOXA ART SoCs.
>>
[ ... ]
>> +
>> +	err = watchdog_register_device(&moxart_wdt->dev);
>> +	if (unlikely(err))
>> +		return err;
>
> This is a probe path. Is the use of unlikely() really appropriate here?
> I suspect it doesn't make any appreciable difference, and should go.
>
Just wondering, for my education - why ? Is there s rule that unlikely()
shall not be used in the probe path ? If so, I would like to know it and
its reasoning to be able to apply it to my own reviews.

Thanks,
Guenter

