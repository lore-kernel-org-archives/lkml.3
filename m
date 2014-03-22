Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaCVV5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 17:57:15 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:22079 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaCVV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 17:57:14 -0400
X-AuditID: cbfec37c-b7f536d0000059f2-cc-532e0738dbce
Message-id: <532E0735.6030907@samsung.com>
Date: Sat, 22 Mar 2014 15:57:09 -0600
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
Subject: Re: [PATCH 3.13 000/149] 3.13.7-stable review
References: <20140321000436.377902063@linuxfoundation.org>
 <532BD009.7020204@roeck-us.net>
In-reply-to: <532BD009.7020204@roeck-us.net>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.241]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hX10Ldr1gg9krrC3mrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxtrpHcwFB1grHr2dwdzAuJali5GTQ0LARGLh8YNQtpjEhXvr2boY
	uTiEBJYxSkzaNIcVwullkpjZtJwZwtnGKPHj3X9GkBZeAS2JU0cfM4PYLAKqEidvTQYbxSag
	LvH59Q52EFtIQE6iaclqsBpRgQiJV2cnskD0Ckr8mHwPzBYRCJZY+3UhI8gCZoGpjBJ3ti0F
	WyAsYCYxadtFNohBMRI/rx9lArE5BXQkvh0/BWYzA9U8alnHDGHLS2xe85YZol5Z4s9liBoJ
	IPv49APsExhFZiHZPQtJ+ywk7QsYmVcxipUWJxcUJ6WnVhjrFSfmFpfmpesl5+duYoREU80O
	xntfbQ4xCnAwKvHwnvikGyzEmlhWXJl7iFGCg1lJhLeFSS9YiDclsbIqtSg/vqg0J7X4ECMT
	B6dUA2P8JrW7mTyKUYfivr43lq17ef/XzrXTsiXtZz6rPj/nXtm1lheFp9m5//1Xf/Rrj1BV
	jFLyFB9R31uaax/qu2xkX1BsWJJ14mfz74nTtvzfst+N0cjg+ye3OWYx7+dvTzBneXlrxtra
	+Z39gr95i4Qv2q99+dD42VXJHyGZnteTF014kS6VsfynEktxRqKhFnNRcSIA2LLNjYQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 11:37 PM, Guenter Roeck wrote:
> On 03/20/2014 05:02 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.13.7 release.
>> There are 149 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun Mar 23 00:03:54 UTC 2014.
>> Anything received after that time might be too late.
>>
>


Compiled, and booted on my test systems. No regressions in dmesg.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
