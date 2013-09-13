Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab3IMAMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:12:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61091 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3IMAMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:12:09 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52325855.8010303@roeck-us.net>
Date: Thu, 12 Sep 2013 17:12:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/16] 3.11.1-stable review
References: <20130912181156.173326121@linuxfoundation.org> <52324216.30503@roeck-us.net> <20130912230756.GC5565@kroah.com>
In-Reply-To: <20130912230756.GC5565@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 04:07 PM, Greg Kroah-Hartman wrote:
> On Thu, Sep 12, 2013 at 03:37:10PM -0700, Guenter Roeck wrote:
>> On 09/12/2013 11:14 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.11.1 release.
>>> There are 16 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat Sep 14 18:10:15 UTC 2013.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.1-rc1.gz
>>> and the diffstat can be found below.
>>>
>>
>> Test results:
>> 	total: 110 pass: 107 skipped: 2 fail: 1
>>
>> The failure is xtensa:allmodconfig. A patch fixing the problem has been submitted,
>> but is not yet available upstream.
>
> What was skipped?
>

Ah, someone noticed :).

Builds are listed as "skipped" if the configuration step fails. Usually
that means that the configuration does not exist, though in rare cases
it may fail for other reasons, which is why I still list it. For 3.11,
skipped builds are arm:ap4evb_defconfig and arm:bonito_defconfig,
both of which have been removed from 3.11.

For qemu tests, skipped means that the test is known to fail with
the affected kernel version, typically because qemu and that kernel
version don't like each other, so I don't bother trying.

Guenter

