Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaBUXld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:41:33 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:53492 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbaBUXlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:41:31 -0500
X-AuditID: cbfec37b-b7f8f6d000007030-74-5307e42a1b39
Message-id: <5307E428.4080502@samsung.com>
Date: Fri, 21 Feb 2014 16:41:28 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.12 00/82] 3.12.13-stable review
References: <20140220235019.483734207@linuxfoundation.org>
In-reply-to: <20140220235019.483734207@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9hX12tJ+zBBr8+yFjMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXx+/crpoJG9oq+DbfZGxhPsXYxcnJICJhITOm4zwhhi0lcuLeerYuRi0NIYBmjxKmD
	t1ggnF4midfPp7BCOBsYJWZ+a2QHaeEV0JJ4NLUVzGYRUJVYPPE2mM0moC7x+fUOMFtIQE6i
	aclqZhBbVCBC4tXZiSwQvYISPybfA7NFBIIl1n5dyAiygFlgBaPE8Zcv2UASwgKmEu+n97FB
	DLKSON52EexWTgFriStv28FsZgEziUct65ghbHmJzWveMkPUK0v8uXyKCeI3BYlHV1vZJzCK
	zEKyexaS9llI2hcwMq9iFCstTi4oTkpPrTDSK07MLS7NS9dLzs/dxAiJm+odjHe/2hxiFOBg
	VOLhdUhlDxZiTSwrrsw9xCjBwawkwquyCCjEm5JYWZValB9fVJqTWnyIkYmDU6qBMf56+a2j
	PQmOE6t3/3np8Mp6W5DLGZaTu051nNzXJL1zufT/Lu7nEc8i3KW6JNfxtJxfGs3Bu/T669m6
	FhrPneWU1R6sn8Qg98FnquPiomf5C6zTedbK1papVG2xuHJZ8Op0vs02OQ7W3su4ezuN425t
	ko5Zf/Wq1NJuvcBcu/8ebW2vLRM3K7EUZyQaajEXFScCAPymRQp5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 04:51 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.13 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Feb 22 23:50:04 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.13-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compile tests and boot tests passed. No dmesg regressions: emerg, crit, 
alert, err are clean. No regressions in warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
