Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaBUXkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:40:53 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:52196 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaBUXkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:40:51 -0500
X-AuditID: cbfec37d-b7f616d0000059df-37-5307e4023cc8
Message-id: <5307E3FF.206@samsung.com>
Date: Fri, 21 Feb 2014 16:40:47 -0700
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
Subject: Re: [PATCH 3.4 00/25] 3.4.82-stable review
References: <20140220234842.483343851@linuxfoundation.org>
In-reply-to: <20140220234842.483343851@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9hP12mJ+zBBjvecFjMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJUx/9QWxoL/bBUPb7xmamA8wdrFyMkhIWAi8ebvekYIW0ziwr31bF2MXBxCAssYJU5v
	ncUI4fQyScz79pAFwtnAKDGjq4EFpIVXQE3i7pYDTCA2i4CqxOLPN8DibALqEp9f72AHsYUE
	5CSalqxmBrFFBSIkXp2dCNUrKPFj8j0wW0QgWGLt14Vg25gFVjBKHH/5kg0kISxgLHHkzQFW
	iEFWEu/uQCzgFLCW2Pn6N9jdzAJmEo9a1jFD2PISm9e8ZYaoV5b4c/kUE8RvChKPrrayT2AU
	mYVk9ywk7bOQtC9gZF7FKFZanFxQnJSeWmGiV5yYW1yal66XnJ+7iRESN7U7GO9/tTnEKMDB
	qMTDOyOdPViINbGsuDL3EKMEB7OSCK/KIqAQb0piZVVqUX58UWlOavEhRiYOTqkGxsktmZFb
	L3jbTTVv4um5H/zp6AuzLIuPUVNWTZ4tssLEJb1sy6O5S33++s0xVj3yIeGklsQuzu+zd17S
	6LS4esyszDvudGqL26mLN0PtbE9uuO45h/etsNrNnvcaM2YbzGrS1jfqf5RdvLe7xJm18hqP
	e8hklZZjaZqb369/cWN2b8gm3y3S35RYijMSDbWYi4oTAZ0CYYt5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 04:51 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.82 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Feb 22 23:48:32 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.82-rc1.gz
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
