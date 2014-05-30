Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbaE3ToK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:44:10 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:16859 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaE3ToH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:44:07 -0400
X-AuditID: cbfec37a-b7f206d000005572-ac-5388df85cf40
Message-id: <5388DF82.6000805@samsung.com>
Date: Fri, 30 May 2014 13:44:02 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.10 00/86] 3.10.41-stable review
References: <20140529043513.451722422@linuxfoundation.org>
 <538744FD.4080709@roeck-us.net>
In-reply-to: <538744FD.4080709@roeck-us.net>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.245]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t9hX93W+x3BBs1t5hZz1q9hs2hevJ7N
	4vKuOWwWTxaeYbKYemoCi8WCjY8YLR71vWV3YPfYOesuu8eJGb9ZPPbPXQPkfm9g9/i8SS6A
	NYrLJiU1J7MstUjfLoErY8kBlYJ+zoobt+eyNjBOY+9i5OSQEDCR+HX0AQuELSZx4d56NhBb
	SGAZo8TJczVdjFxAdi+TxOQLD1khnG2MEgun32PuYuTg4BXQkjh0RAukgUVAVeL3251gg9gE
	1CU+v97BDjFITqJpyWqwclGBCInHF4RAwrwCghI/Jt8DKxcRCJZY+3UhI8h4ZoFdjBJTljcz
	giSEBUwlPk6cygwxJ0Zi+e1lYHFOAR2Jlg1NYHFmATOJRy3roGx5ic1r3kLVK0v8uXyKCeIx
	ZYnnMw6yTGAUmYVk9ywk7bOQtC9gZF7FKFZanFxQnJSeWmGoV5yYW1yal66XnJ+7iRESRVU7
	GO98tTnEKMDBqMTD6zCjI1iINbGsuDL3EKMEB7OSCO/zI0Ah3pTEyqrUovz4otKc1OJDjEwc
	nFINjNyJyUK5OpeuP1wpWs+2ytZI9tfmR2Z3tn+2qY9KW6hvqLl0otXyVzI3r00PbyzIcNbZ
	r/bswVxbDZVrPsJX2/Z1rWs7Yeb3SETSuoVX9oLZ/c70bVN7be2ubL7ZfT+n+vhCBTnJBqYN
	ISqn1lbfe/btsy9bt8upA/3eYVEJ9e9LWLg1np+frsRSnJFoqMVcVJwIAIibQdSAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 08:32 AM, Guenter Roeck wrote:
> On 05/28/2014 09:36 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.10.41 release.
>> There are 86 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat May 31 04:34:49 UTC 2014.
>> Anything received after that time might be too late.
>>
>
> Build results:
>      total: 143 pass: 134 skipped: 6 fail: 3
>
> Qemu tests all passed.
>
> For reference, failing builds are
>
> unicore32:defconfig        - still fails for all releases
> powerpc:ppc64e_defconfig    - fail if built with binutils 2.4; patch
> pending
> powerpc:chroma_defconfig    - fail if built with binutils 2.4; patch
> pending
>
> Results are as expected. Details are available at
> http://server.roeck-us.net:8010/builders.
>

Compiled and booted on my test systems. No dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
