Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153Ab3GLRVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:21:38 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:63652 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965094Ab3GLRVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:21:36 -0400
X-AuditID: cbfec37b-b7f306d0000047de-07-51e03b1ff214
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/11] 3.4.53-stable review
Thread-topic: [ 00/11] 3.4.53-stable review
Thread-index: AQHOfo0XkWE4RlL6dkOGZ5BM4vYV7w==
Date: Fri, 12 Jul 2013 17:21:33 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61739C95@sisaex02sj>
References: <20130711220545.542911892@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+wn6689YNAg+nH2C3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MrY8bSPuWCKQMWGvfINjMt4uxg5OSQETCRWPljMAmGLSVy4t56ti5GLQ0hgGaPEir+d
	LBBOL5PE6tvNzBDOfEaJ612fWUFa2ATUJT6/3sEOYosIGEv0n50FZjMLHGOS6OgsA7GFBbQk
	fv28wwRRoy3R+ngFkM0BZOtJnNuoARJmEVCVOLb0KNgVvAL2Esu3H2YGsYUErCQW/usAG8kI
	dN33U2uYIMaLSzS33oS6WkBiyZ7zzBC2qMTLx/9YQcZLCChKbF9tBVGuJbF+53GoVm2JJ+8u
	sEKsEpT4MfkeywRGsVlIps5C0jILScssJC0LGFlWMYqVFicXFCelp1YY6RUn5haX5qXrJefn
	bmKExF31Dsa7X20OMQpwMCrx8DqIPggUYk0sK67MPcQowcGsJML73xAoxJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgTHt/+Pu0zkPdOs2XXfsZOJ90rVqoiLrLKfIR782W3u9sN9v/uTB7Mrd9geO
	L/Hp0C6cqlMy0bqNt6BxqfK+HfPO50xdZMvnGcH8M2xFdmZeinXPI+ODLyJqLEsigpLE76S+
	uJojNXnN7N2/ciyXvFer/zK1bdqd674CDcJpD/aHrPvmaCxp7KvEUpyRaKjFXFScCAC2xnmF
	mQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 05:19 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.53 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Jul 13 22:04:03 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.53-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.85, 3.4.52, 3.9.9, and 3.10

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.53-rc1, 3.9.10-rc1, 3.10.1-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.86-rc1, 3.4.53-rc1, 3.9.10-rc1, and 3.10.1-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.86-rc1, 3.4.53-rc1, 3.9.10-rc1, and 3.10.1-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.9.y, and 3.10.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, 3.9.y, and 3.10.y
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
