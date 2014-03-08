Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaCHOf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 09:35:56 -0500
Received: from mail.active-venture.com ([67.228.131.205]:54505 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaCHOfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 09:35:54 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <531B2AC8.1050205@roeck-us.net>
Date: Sat, 08 Mar 2014 06:35:52 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/99] 3.4.83-stable review
References: <20140308010611.468206150@linuxfoundation.org> <87a9d1nhrk.wl%satoru.takeuchi@gmail.com>
In-Reply-To: <87a9d1nhrk.wl%satoru.takeuchi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 01:47 AM, Satoru Takeuchi wrote:
> At Fri,  7 Mar 2014 17:06:56 -0800,
> Greg Kroah-Hartman wrote:
>>
>> This is the start of the stable review cycle for the 3.4.83 release.
>> There are 99 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Mon Mar 10 01:05:53 UTC 2014.
>> Anything received after that time might be too late.
>
> This kernel passed my test.
>

Same here.

Built results:
	total: 119 pass: 97 skipped: 18 fail: 4

qemu tests all passed.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

