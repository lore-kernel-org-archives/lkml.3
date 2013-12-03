Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3LCOcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:32:43 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57479 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3LCOcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:32:42 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <529DEB88.9020100@roeck-us.net>
Date: Tue, 03 Dec 2013 06:32:40 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Jingoo Han <jg1.han@samsung.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 10/39] hwmon: remove DEFINE_PCI_DEVICE_TABLE macro
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>	<001f01ceefb3$b1968820$14c39860$%han@samsung.com>	<20131203001741.GA18237@roeck-us.net> <20131203090232.7ba0e002@endymion.delvare>
In-Reply-To: <20131203090232.7ba0e002@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 12:02 AM, Jean Delvare wrote:
> On Mon, 2 Dec 2013 16:17:41 -0800, Guenter Roeck wrote:
>> On Tue, Dec 03, 2013 at 08:10:29AM +0900, Jingoo Han wrote:
>>> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
>>> is not preferred.
>>>
>>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>>
>> Acked-by: Guenter Roeck <linux@roeck-us.net>
>
> Acked-by: Jean Delvare <khali@linux-fr.org>
>
> too. I never liked this macro and I'm very happy to see it go.
>

Same here. I'll take it through my -next tree.

Thanks,
Guenter

