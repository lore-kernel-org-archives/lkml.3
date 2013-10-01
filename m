Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3JATZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:25:48 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:45668 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3JATZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:25:46 -0400
X-AuditID: cbfec37c-b7fd86d00000670b-44-524b21b98dcb
Message-id: <524B21B7.1040806@samsung.com>
Date: Tue, 01 Oct 2013 13:25:43 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/22] 3.4.64-stable review
References: <20130929191158.889693326@linuxfoundation.org>
In-reply-to: <20130929191158.889693326@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hX92dit5BBj2LTC3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mr4NvUEY0E3T8Xl7i+MDYyPObsYOTkkBEwkFvx7xQhhi0lcuLeerYuRi0NIYBmjxOqv
	r1kgnF4miR1PvkE5GxklPt25yQrSwiugJbH3xh+gdg4OFgFVibdv1EDCbALqEp9f72AHsYUE
	5CSalqxmBrFFBSIkVi55ANUqKPFj8j0WEFtEwFii/+wssHpmgWOMEgubTUBsYaDxx++dZQEZ
	LyRgJbHjoA1ImFPAWuLNwZ9sEOXWEisnbWOEsOUlNq95ywyxVlniz+VTTCCtEgKKEttXW01g
	FJmFZPEsJN2zkHQvYGRexShWWpxcUJyUnlphrFecmFtcmpeul5yfu4kREi81OxjvfbU5xCjA
	wajEw1vw2CtIiDWxrLgy9xCjBAezkghvL793kBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGs36n
	ItdHex5n/zn1SO7f9yNW2704Y4Mt5HyTjaeK5Ci8ZljUv4/bZmZdGxuL9BmB+6wNxUHNk1p0
	Vu2q1J2l+ozJwXvt1sTyT2vMTq7vZ1WWOx0f4yN+3fbpA10v3SquSj7tpV+uftj651Xjp5ia
	qz9tLglbxr6bcHhjXN2Ky6/1tlx0/39CiaU4I9FQi7moOBEAFNN/0HUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 01:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.64 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Oct  1 19:11:47 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.64-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.4.64-rc1 applied cleanly to 3.4.63

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Cross-compile testing: HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: not applicable
blackfin: defconfig passed
c6x: dsk6455_defconfig passed - defconfig isn't supported
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig passed
sh: defconfig passed
sparc: defconfig passed
tile: tilegx_defconfig passed

-- Shuah
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
