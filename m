Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaCHRKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 12:10:08 -0500
Received: from mail.active-venture.com ([67.228.131.205]:53406 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaCHRKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 12:10:06 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <531B4EE8.3090003@roeck-us.net>
Date: Sat, 08 Mar 2014 09:10:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/99] 3.4.83-stable review
References: <20140308010611.468206150@linuxfoundation.org> <87a9d1nhrk.wl%satoru.takeuchi@gmail.com> <531B2AC8.1050205@roeck-us.net> <20140308161839.GA26012@kroah.com>
In-Reply-To: <20140308161839.GA26012@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 08:18 AM, Greg Kroah-Hartman wrote:
> On Sat, Mar 08, 2014 at 06:35:52AM -0800, Guenter Roeck wrote:
>> On 03/08/2014 01:47 AM, Satoru Takeuchi wrote:
>>> At Fri,  7 Mar 2014 17:06:56 -0800,
>>> Greg Kroah-Hartman wrote:
>>>>
>>>> This is the start of the stable review cycle for the 3.4.83 release.
>>>> There are 99 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Mon Mar 10 01:05:53 UTC 2014.
>>>> Anything received after that time might be too late.
>>>
>>> This kernel passed my test.
>>>
>>
>> Same here.
>>
>> Built results:
>> 	total: 119 pass: 97 skipped: 18 fail: 4
>>
>> qemu tests all passed.
>>
>> Details are available at http://server.roeck-us.net:8010/builders.
>
> Thanks to both of you for testing this, much appreciated.
>

You are welcome.

Can you possibly add me to the cc: of your introductory e-mail
announcing new stable releases ? Sometimes it seems to get lost
and isn't available on any of the 'common' archives (this one
did not make it to lkml, for example, and many of the individual
mails didn't make it into the stable mailing list at gmane).

Thanks,
Guenter

