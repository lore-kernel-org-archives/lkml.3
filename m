Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaCIETL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 23:19:11 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:42585 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaCIETI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 23:19:08 -0500
X-AuditID: cbfec37a-b7fc06d00000555a-2a-531bebba6f80
Message-id: <531BEBB1.1080905@samsung.com>
Date: Sat, 08 Mar 2014 21:18:57 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/99] 3.4.83-stable review
References: <20140308010611.468206150@linuxfoundation.org>
 <87a9d1nhrk.wl%satoru.takeuchi@gmail.com> <531B2AC8.1050205@roeck-us.net>
 <20140308161839.GA26012@kroah.com> <531B4EE8.3090003@roeck-us.net>
 <87pplwv2ia.wl%satoru.takeuchi@gmail.com>
In-reply-to: <87pplwv2ia.wl%satoru.takeuchi@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.15]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t9hX91dr6WDDX7P1bWYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCy+/nSwWLDxEaPFo7637A4cHjtn3WX3ODHjN4vH/rlr2D12fm9g
	9/i8SS6ANYrLJiU1J7MstUjfLoEro+nLJ/aCnfwVt65uYWxgXMLTxcjJISFgIvH6ykYWCFtM
	4sK99WxdjFwcQgLLGCUOf/3ECOH0Mkn8Wf2BCcLZxCix/+UaRpAWXgEtiStn17KB2CwCqhKH
	ltxiArHZBNQlPr/ewQ5iCwnISTQtWc0MYosKREi8OjuRBaJXUOLH5HtgtohAqMTDq9/YQRYw
	C/xklGhpnM4KkhAWMJaYdfEEK8Tm74wSD68tBdvMKWAmcXfBFbBtzALWEisnbWOEsOUlNq95
	ywyxWVniz+VTTBDPKUqcaJ3EOIFRZBaS5bOQtM9C0r6AkXkVo1hpcXJBcVJ6aoWhXnFibnFp
	Xrpecn7uJkZIXFXtYLzz1eYQowAHoxIP74NJ0sFCrIllxZW5hxglOJiVRHhfdgKFeFMSK6tS
	i/Lji0pzUosPMTJxcEo1MHbaHuc4kxs8cdrRXKdd3E4Tlp7Yp5pzx2G1+Od2LmajfXwCF/Z+
	/jn9CndD3WSB9rd8Jo2VR8VsWos2CB3vMFkovrfyz4rzPM4SS/ifVn9v+fBJyu5j9pTar5k3
	Tqz1e7X+wv3Lk8K3uhwy4WHscKxSOT3h2c36+zs/bZZatJ+b//ZGR6n2BAclluKMREMt5qLi
	RACoW7yCiQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 01:50 PM, Satoru Takeuchi wrote:
> At Sat, 08 Mar 2014 09:10:00 -0800,
> Guenter Roeck wrote:
>>
>> On 03/08/2014 08:18 AM, Greg Kroah-Hartman wrote:
>>> On Sat, Mar 08, 2014 at 06:35:52AM -0800, Guenter Roeck wrote:
>>>> On 03/08/2014 01:47 AM, Satoru Takeuchi wrote:
>>>>> At Fri,  7 Mar 2014 17:06:56 -0800,
>>>>> Greg Kroah-Hartman wrote:
>>>>>>
>>>>>> This is the start of the stable review cycle for the 3.4.83 release.
>>>>>> There are 99 patches in this series, all will be posted as a response
>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Mon Mar 10 01:05:53 UTC 2014.
>>>>>> Anything received after that time might be too late.
>>>>>
>>>>> This kernel passed my test.
>>>>>
>>>>
>>>> Same here.
>>>>
>>>> Built results:
>>>> 	total: 119 pass: 97 skipped: 18 fail: 4
>>>>
>>>> qemu tests all passed.
>>>>
>>>> Details are available at http://server.roeck-us.net:8010/builders.
>>>
>>> Thanks to both of you for testing this, much appreciated.
>>>
>>
>> You are welcome.
>>
>> Can you possibly add me to the cc: of your introductory e-mail
>> announcing new stable releases ? Sometimes it seems to get lost
>> and isn't available on any of the 'common' archives (this one
>> did not make it to lkml, for example, and many of the individual
>> mails didn't make it into the stable mailing list at gmane).
>
> Me too.
>

Compile tests and boot tests passed on all my test systems. No dmesg 
regressions: emerg, crit, alert, err are clean. No regressions in warn.

I have a similar request for cc. The first message seems to get lost and 
messages don't get threaded correctly. Could you please cc me on the of 
your introductory e-mail.

thanks,
-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
