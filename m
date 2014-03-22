Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaCVV4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 17:56:14 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:59767 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaCVV4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 17:56:13 -0400
X-AuditID: cbfec37b-b7f8f6d000007030-45-532e06fbe981
Message-id: <532E06F8.4020205@samsung.com>
Date: Sat, 22 Mar 2014 15:56:08 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/35] 3.4.84-stable review
References: <20140321001054.038170009@linuxfoundation.org>
 <532BCD8F.2020505@roeck-us.net>
In-reply-to: <532BCD8F.2020505@roeck-us.net>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.241]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hP93fbHrBBj+umFnMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujPNnVrMX7GKtuPNgDXMD42qWLkZODgkBE4mea1tYIWwxiQv31rN1
	MXJxCAksY5T4u3wVM4TTyyTRvbmVBcLZxihx9O4HJpAWXgEtiUl3rjOD2CwCqhI/Jp9iBLHZ
	BNQlPr/ewQ5iCwnISTQtWQ1WIyoQIfHq7EQWiF5BoPp7YLaIQLDE2q8LGUEWMAtMZZS4s20p
	kMPBISxgLLHoQADEnBiJ3VtXgdVzCuhIXGlcCXY2s4CZxKOWdcwQtrzE5jVvmSHqlSX+XD7F
	BPGassTx6QfYJzCKzEKyehaS9llI2hcwMq9iFCstTi4oTkpPrTDSK07MLS7NS9dLzs/dxAiJ
	peodjHe/2hxiFOBgVOLhPfFJN1iINbGsuDL3EKMEB7OSCG8Lk16wEG9KYmVValF+fFFpTmrx
	IUYmDk6pBsZo25dP1J8eLo9r5q4OCa0MaxH0ei+V8f9sGUNBi8eZ7ImaagztRteDTwW4fPry
	0zGlpPu4YfymCWbnnjb3dKTUT7u50//S9tv5ScsVJU28CxfEdkyKeP8w77DpasZ5G6O+zv6z
	rPbr86hq52vTz4f9592eeFGwTcSkOOKx+MLLzx8Er76/MEeJpTgj0VCLuag4EQC0ifRBgwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 11:26 PM, Guenter Roeck wrote:
> On 03/20/2014 05:10 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.4.84 release.
>> There are 35 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun Mar 23 00:10:42 UTC 2014.
>> Anything received after that time might be too late.
>>

Compiled, and booted on my test systems. No regressions in dmesg.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
