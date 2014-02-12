Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaBLSt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:49:57 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:49467 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaBLStz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:49:55 -0500
X-AuditID: cbfec37a-b7ef66d000004f2b-c0-52fbc252148d
Message-id: <52FBC250.4050709@samsung.com>
Date: Wed, 12 Feb 2014 11:49:52 -0700
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
Subject: Re: [PATCH 3.12 000/107] 3.12.11-stable review
References: <20140211184748.191276235@linuxfoundation.org>
In-reply-to: <20140211184748.191276235@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.3]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hP92gQ7+DDKY+VraYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvjzKZvzAUr2Csur+hla2B8wdrFyMkhIWAi8eHHXyYIW0ziwr31bF2MXBxCAssYJXZP
	WQ7l9DJJLPp0ngnC2cAoMWndFTaQFl4BLYlZLa2MIDaLgKrEz3kXwWw2AXWJz693sIPYQgJy
	Ek1LVjOD2KICERKvzk5kgegVlPgx+R6YLSIQLLH260JGkAXMAisYJY6/fAm2QFjAXOJg82IW
	iEFWEnMX3Acq4uDgFLCW6F/EBxJmFjCTeNSyjhnClpfYvOYtM0S5ssSfy6egXlOQWH/hMOsE
	RpFZSFbPQtI+C0n7AkbmVYxipcXJBcVJ6akVhnrFibnFpXnpesn5uZsYIVFTtYPxzlebQ4wC
	HIxKPLwWy34HCbEmlhVX5h5ilOBgVhLhNWoGCvGmJFZWpRblxxeV5qQWH2Jk4uCUamD0tzW2
	Vqx7cKz/Kzcv862VVn8al3eemZ/6gvNhsaJZ/rVbn56FPw7QmPa1edWzj88PfUnf8P3kg6DX
	i2uNTaN+rNsgbPK4zHlPqWjBz7IQ5gS+/M3v15upnez3/tVWphXcl7zUOeT9v+m3fsqr+2p1
	2QRdu+920OxPoxvXpTPH5zr1lEZN33lTiaU4I9FQi7moOBEA8gygIHgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 12:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.11 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Feb 13 18:47:29 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.11-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Worked fine on all my test systems. Compile tests and boot tests passed. 
No dmesg regressions: emerg, crit, alert, err are clean. No regressions 
in warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
