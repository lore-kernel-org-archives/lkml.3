Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaBEUmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:42:06 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:22584 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbaBEUl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:41:56 -0500
X-AuditID: cbfec37d-b7ff46d000005528-34-52f2a2147504
Message-id: <52F2A20C.3080509@samsung.com>
Date: Wed, 05 Feb 2014 13:41:48 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.12 000/133] 3.12.10-stable review
References: <20140204210737.008598235@linuxfoundation.org>
 <52F1DCB9.7060200@roeck-us.net>
In-reply-to: <52F1DCB9.7060200@roeck-us.net>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX12RRZ+CDJ7PF7KYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF158OFgs2PmK0eNT3lt2B3WPnrLvsHidm/Gbx2D93DZD7vYHd4/MmuQDW
	KC6blNSczLLUIn27BK6MTz0PGQumcFcs2POXpYHxHUcXIyeHhICJxOqW3SwQtpjEhXvr2boY
	uTiEBJYxSuzoXAjl9DJJTLt7jR3C2cAo8XP6VVaQFl4BLYnp3zsYQWwWAVWJbYv3soHYbALq
	Ep9f72AHsYUE5CSalqxmBrFFBSIkXp2dyALRKyjxY/I9MFtEoFzixv7FTCALmAVWMEocf/kS
	bJCwgLlEe99aNohBMRL7dk8GszkFdCRezl8FtphZwEziUcs6ZghbXmLzmrfMEPXKEn8un2KC
	+E1BYsWNNywTGEVmIdk9C0n7LCTtCxiZVzGKlRYnFxQnpadWmOgVJ+YWl+al6yXn525ihMRS
	7Q7G+19tDjEKcDAq8fB6zv8UJMSaWFZcmXuIUYKDWUmE98R0oBBvSmJlVWpRfnxRaU5q8SFG
	Jg5OqQbGqa/Wblc9bjeZWZRTjnn5/SX1N7YbazX6PDwRPCNgN2f3opmLPZdt+Cmr9mz/rzlX
	LM4+CUmTuBPL0/BT+8I6xqcKAje9P61d+e1t+O5Zml8/ttmGLQ2+ujUr++TRdws9msu+7KoK
	mNPGvPqL8IEvN76+z99p1LBsqf6lX+pzU8+LK4XWhf/UeqbEUpyRaKjFXFScCACpMz/+gwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 11:39 PM, Guenter Roeck wrote:
> On 02/04/2014 01:06 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.12.10 release.
>> There are 133 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu Feb  6 21:07:17 UTC 2014.
>> Anything received after that time might be too late.
>>
>
>
> Version tested: v3.12.9-132
>
> Build results:
>      total: 126 pass: 121 skipped: 5 fail: 0
>
> qemu tests all passed.
>
> Results are as expected.
>
> Details are available at http://server.roeck-us.net:8010/builders.
>
> Guenter
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

Patch applied cleanly. boot tests passed on all test systems. No dmesg 
regressions: emerg, crit, alert, err are clean. No regressions in warn.

Minor Note: git apply --index complained about extra white space at the 
end of patch file. patch -p1 worked just fine.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
