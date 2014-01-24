Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaAXRMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:12:41 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:27432 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaAXRMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:12:40 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-63-52e29f063f0d
Message-id: <52E29F04.2070106@samsung.com>
Date: Fri, 24 Jan 2014 10:12:36 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Thomas Pugliese <thomas.pugliese@gmail.com>
Cc: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, alan@linux.intel.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] staging/usbip: Add missing speeds to userspace
 speed_strings array
References: <1390420383-3933-1-git-send-email-shuah.kh@samsung.com>
 <alpine.DEB.2.10.1401241106380.28215@mint32-virtualbox>
In-reply-to: <alpine.DEB.2.10.1401241106380.28215@mint32-virtualbox>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.10]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9hP122+Y+CDFYc1Le48PwCi8WeM7/Y
	LZoXr2ezuLxrDpvFomWtzBbPruVYfP3pYPFl0ks2Bw6PJRfuMHnc23eYxWPnrLvsHvNOBnrs
	n7uG3ePzJrkAtigum5TUnMyy1CJ9uwSujCPrJrIWfOeq+H43sIGxgbOLkZNDQsBE4vCpTlYI
	W0ziwr31bF2MXBxCAssYJb5sn8QGkhAS6GWSmPJaBCKxiVFi0o+jYB28AloSDbMXMoHYLAKq
	Eq3vXoI1sAmoS3x+vYMdollOomnJamYQW1QgQuLV2YksEL2CEj8m3wOzRQT0JTb8PMcCsoBZ
	4D6jxLN1zxhBEsICkRIL+k4BLeAAGlQr8ehcKkiYU8BF4ufaq2C9zALWEisnbWOEsOUlNq95
	ywyxV1niz2WIVgkBRYkXD60mMIrMQrJ5FpLuWUi6FzAyr2IUKy1OLihOSk+tMNIrTswtLs1L
	10vOz93ECImp6h2Md7/aHGIU4GBU4uH9EPwwSIg1say4MvcQowQHs5II76rpj4KEeFMSK6tS
	i/Lji0pzUosPMTJxcEo1MFbNLuY0ZhMTeekSPvW3d7f4ioQIJftuCc8M7Xk/pSZ0WQe5ZDKr
	3r1pXeAkZtcbY3ksMmplzeZX3zz/Kne5MOvZfOf5Mj/xUXZlkpOc7+7+w91/ufiUXKeJ+q1l
	7q2QiLwee/qyZ+B8l8WdKkyyEed6WFJ/XN80Y8JRti8akQJymnl32pKVWIozEg21mIuKEwHW
	EuykhwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 10:08 AM, Thomas Pugliese wrote:
>
>
> On Wed, 22 Jan 2014, Shuah Khan wrote:
>
>> Add speed strings for usb wireless and 3.0 to speed_strings array.
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   drivers/staging/usbip/userspace/libsrc/usbip_common.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
>> index 66f03cc..8cb4fcc 100644
>> --- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
>> +++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
>> @@ -23,6 +23,8 @@ static const struct speed_string speed_strings[] = {
>>   	{ USB_SPEED_LOW,  "1.5", "Low Speed(1.5Mbps)"  },
>>   	{ USB_SPEED_FULL, "12",  "Full Speed(12Mbps)" },
>>   	{ USB_SPEED_HIGH, "480", "High Speed(480Mbps)" },
>> +	{ USB_SPEED_WIRELESS, "2.5", "Wireless"},
>> +	{ USB_SPEED_SUPER, "5000", "Super Speed(5000Mbps)" },
>>   	{ 0, NULL, NULL }
>>   };
>>
>> --
>
> Wireless USB supports variable speeds from 53.3Mbps to 480Mbps.  I'm not
> sure how you want to represent that but "2.5" doesn't seem to apply.
>

Would "variable" be better suited in this case?

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
