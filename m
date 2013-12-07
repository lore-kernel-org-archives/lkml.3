Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab3LGWQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 17:16:49 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:13931 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3LGWQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 17:16:45 -0500
X-AuditID: cbfec37d-b7fa86d000003175-91-52a39e4c4407
Message-id: <52A39E4A.2080708@samsung.com>
Date: Sat, 07 Dec 2013 15:16:42 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/32] 3.4.73-stable review
References: <20131206214956.830407026@linuxfoundation.org>
In-reply-to: <20131206214956.830407026@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX12feYuDDDbcNbGYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvj8/FprAVnOCvefb/E2MB4kr2LkZNDQsBEYmXzRjYIW0ziwr31QDYXh5DAMkaJO38W
	MoEkhAR6mSS2b5OBSGxilHi9/z9YgldAS2L7hmYwm0VAVeL308tgU9kE1CU+v97BDtEsJ9G0
	ZDUziC0qECFxdPUzVoheQYkfk++xgNgiAsESa78uZARZwCywglHi+MuXYCcJCxhL3H9wkQVi
	kJXEljOzwGxOAWuJZ/t2gA1iBrJXTtrGCGHLS2xe85YZol5Z4s/lU0DHcQC9piixfbXVBEaR
	WUhWz0LSPQtJ9wJG5lWMYqXFyQXFSempFSZ6xYm5xaV56XrJ+bmbGCExU7uD8f5Xm0OMAhyM
	Sjy8FRaLgoRYE8uKK3MPMUpwMCuJ8IbfBArxpiRWVqUW5ccXleakFh9iZOLglGpg1JDiUBNW
	lLu9vNDwfGhOYcdyF/Z11f4HGlevE4hcz6M8w/TcvNXp601FbGrcRDgnJj2InCYlEPHDRVkg
	48zTE8u4kxz2Wa1OXyzVEX1lxZ49ic2evpfinn9kWFw6J5r3f5ZfBsuHzZfOLPqz89G9yM/L
	Yn+sOZH20bNhQ/w2yaT5qsf0kiI3KbEUZyQaajEXFScCAOI79sR3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 02:52 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.73 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Dec  8 21:49:13 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.73-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

patch applied cleanly.
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed
dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Test systems

     Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
     HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
     Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
