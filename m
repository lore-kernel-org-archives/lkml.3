Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaDYCDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 22:03:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62900 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaDYCDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 22:03:02 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5359C253.4010604@roeck-us.net>
Date: Thu, 24 Apr 2014 19:02:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/23] 3.10.38-stable review
References: <20140424214825.933835556@linuxfoundation.org> <5359A9E2.1010202@roeck-us.net> <20140425014907.GA27190@kroah.com>
In-Reply-To: <20140425014907.GA27190@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 06:49 PM, Greg Kroah-Hartman wrote:
> On Thu, Apr 24, 2014 at 05:18:42PM -0700, Guenter Roeck wrote:
>> On 04/24/2014 02:48 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.10.38 release.
>>> There are 23 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat Apr 26 21:48:09 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>> 	total: 126 pass: 122 skipped: 4 fail: 0
>>
>> Qemu tests all passed. Results are as expected.
>>
>> Details are available at http://server.roeck-us.net:8010/builders.
>>
>> But wait ... I have 24 patches in this series, not 23. Did you add one ?
>
> I count 23, I removed one a few days ago, did your scrips miss that?
>

Yes, looks like it (for both releases). Wonder what happened.
I'll update manually and let you know if there are any problems.

Guenter

