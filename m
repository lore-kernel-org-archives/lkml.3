Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaCVV4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 17:56:44 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:63845 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaCVV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 17:56:42 -0400
X-AuditID: cbfec37a-b7fc06d00000555a-45-532e0719f2db
Message-id: <532E0717.4010506@samsung.com>
Date: Sat, 22 Mar 2014 15:56:39 -0600
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
Subject: Re: [PATCH 3.10 00/85] 3.10.34-stable review
References: <20140321000558.606667505@linuxfoundation.org>
 <532BCDE4.2060700@roeck-us.net>
In-reply-to: <532BCDE4.2060700@roeck-us.net>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.241]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX11Jdr1gg5XndCzmrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxoqHugX7WSsedmxkbmBcw9LFyMkhIWAice3BYjYIW0ziwr31QDYX
	h5DAMkaJvdcuMUI4vUwSW/e3skA42xgl5ixtYQRp4RXQklj++z4TiM0ioCqxc8sUZhCbTUBd
	4vPrHewgtpCAnETTktVgcVGBCIlXZyeyQPQKSvyYfA/MFhEIllj7dSHYNmaBqYwSd7YtBVsg
	LGAq8f1nMxvEoBiJaw2zwBo4BXQkLv/6xApiMwuYSTxqWccMYctLbF7zlhmiXlniz+VTTBC/
	KUscn36AfQKjyCwku2chaZ+FpH0BI/MqRrHS4uSC4qT01ApDveLE3OLSvHS95PzcTYyQWKra
	wXjnq80hRgEORiUe3hOfdIOFWBPLiitzDzFKcDArifC2MOkFC/GmJFZWpRblxxeV5qQWH2Jk
	4uCUamCcfbX1d9k07xWndM42vAvdeOFzpMMfXp/Ks/Pn8ySr7s4OsxOMiTh51Pr9D/OQ01Zu
	N2pDfLsmcvQL93zeyprxoKVSa3buNmeJvlgOh1myqxeJiy92tmS1sqhUPCCscv/r3T+1Lv35
	vleK/Xr+2bbvPLVxy0n7k27PTJuKtocclbBfOPnCPh0lluKMREMt5qLiRAAX4pazgwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 11:28 PM, Guenter Roeck wrote:
> On 03/20/2014 05:09 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.10.34 release.
>> There are 85 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun Mar 23 00:05:33 UTC 2014.
>> Anything received after that time might be too late.
>>


Compiled, and booted on my test systems. No regressions in dmesg.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
