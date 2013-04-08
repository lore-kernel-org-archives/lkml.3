Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935655Ab3DHS1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:27:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57922 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934855Ab3DHS1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:27:32 -0400
Message-ID: <51630C01.6010601@ti.com>
Date: Mon, 8 Apr 2013 14:27:13 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "edubezval@gmail.com" <edubezval@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Tyrel Datwyler <turtle.on.the.radio@gmail.com>,
        <eduardo.valentin@ti.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: omap-thermal: remove trailing whitespace from
 omap-bandgap.c
References: <1365385640-10443-1-git-send-email-turtle.on.the.radio@gmail.com> <20130408172233.GA26206@kroah.com> <CAC-25o9wUGRAjaO1jEbRB9AdwT7sgGcH2M2oyh4-rSyoCiSm7Q@mail.gmail.com>
In-Reply-To: <CAC-25o9wUGRAjaO1jEbRB9AdwT7sgGcH2M2oyh4-rSyoCiSm7Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tyrel,


On 08-04-2013 14:24, edubezval@gmail.com wrote:
> Fixing to right email address.
>
> On Mon, Apr 8, 2013 at 1:22 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Sun, Apr 07, 2013 at 06:47:20PM -0700, Tyrel Datwyler wrote:
>>> This patch removes trailing whitespace from a blank line in omap-bandgap.c as
>>> detected by the checkpatch.pl tool.
>>>
>>> Signed-off-by: Tyrel Datwyler <turtle.on.the.radio@gmail.com>

Thanks for your patch. But as mentioned by Greg, this file does not 
exist anymore, it has been renamed. Check latest linux-next.

Besides, the issue you are fixing has been already removed. Also check 
latest linux-next and you will see the driver under:
drivers/staging/ti-soc-thermal/ti-bandgap.c

Thanks, please keep sending your patches and copy my email address so I 
will give you a quick response.

>>> ---
>>>   drivers/staging/omap-thermal/omap-bandgap.c | 2 +-
>>
>> This file no longer is in my tree, are you sure you made this against
>> the proper branch?  Please always make staging patches against the
>> linux-next tree.
>>
>> thanks,
>>
>> greg k-h
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>

