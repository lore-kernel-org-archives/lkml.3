Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaDDNbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:31:04 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:55378 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaDDNbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:31:01 -0400
X-AuditID: cbfec37a-b7fc06d00000555a-c8-533eb4131b33
Message-id: <533EB411.3030905@samsung.com>
Date: Fri, 04 Apr 2014 07:30:57 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.13 00/22] 3.13.9-stable review
References: <20140401040703.045139933@linuxfoundation.org>
 <533B53D6.9030304@roeck-us.net> <20140403224519.GA13754@kroah.com>
In-reply-to: <20140403224519.GA13754@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.242]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX12RLXbBBpOyLeasX8Nm0bx4PZvF
	5V1z2CyeLDzDZDH11AQWiwUbHzFaPOp7y+7A7rFz1l12jxMzfrN47J+7Bsj93sDu8XmTXABr
	FJdNSmpOZllqkb5dAlfGzM4VrAWXOCo+LF7B1sD4kq2LkZNDQsBE4tmSmUwQtpjEhXvrgeJc
	HEICyxglGmcvYYRwepkkPi1+xg7hbGOUWH9wNlgLr4CWxNErnxhBbBYBVYkJnxaB2WwC6hKf
	X+9gB7GFBOQkmpasZgaxRQUiJF6dncgC0Sso8WPyPTBbRCBS4kTLFrDVzAJbGCVOtS8AaxAG
	um/LrV+sEIPqJXq/PAC7m1NAX+LjrU1gC5gFrCVWTtrGCGHLS2xe85YZol5Z4s/lU1C/KUvs
	ezCHcQKjyCwku2chaZ+FpH0BI/MqRrHS4uSC4qT01ApDveLE3OLSvHS95PzcTYyQWKrawXjn
	q80hRgEORiUeXo5022Ah1sSy4srcQ4wSHMxKIrx1E+yChXhTEiurUovy44tKc1KLDzEycXBK
	NTC65aT2/tX+t5VThpdBWMBiwYN5DMs8ZN1vrj7j2fY1NWl7x8Hila6Lc/55r81u5li8oTQz
	4GvzQvVijbe7z3Hl+9z+YjpfhC1ipp3eqfUlX0t+HJp52noicyBnwFzj37GqEbVPyw+tzw6M
	uV0y+wzH0xt/cqw6/fZrS/7njPsvd3VZgOC7ff5KLMUZiYZazEXFiQDZWjengwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 04:45 PM, Greg Kroah-Hartman wrote:
> On Tue, Apr 01, 2014 at 05:03:34PM -0700, Guenter Roeck wrote:
>> On 03/31/2014 09:08 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.13.9 release.
>>> There are 22 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu Apr  3 04:06:39 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>>          total: 126 pass: 122 skipped: 4 fail: 0
>>
>> Qemu tests all passed. The previously observed powerpc failures are gone
>> with this version.
>>
>> Details are available at http://server.roeck-us.net:8010/builders.
>
> Thanks for testing all of these.
>
> greg k-h
>

Looks like I missed responding to this one. 3.13.9 worked on all my test 
systems.

-- Shuah
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
