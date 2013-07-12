Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164Ab3GLRW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:22:58 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:63689 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073Ab3GLRW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:22:57 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-97-51e03b704956
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 0/8] 3.0.86-stable review
Thread-topic: [ 0/8] 3.0.86-stable review
Thread-index: AQHOfpCGm5UkSBD0Q02pcRoNc6LOGw==
Date: Fri, 12 Jul 2013 17:22:54 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61739CBB@sisaex02sj>
References: <20130711221931.216612791@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+wr26B9YNAg+nf+C3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MqYd/wWa8EKgYrfxycxNzBu5+1i5OSQEDCRePphDhuELSZx4d56IJuLQ0hgGaPEzG97
	GCGcXiaJDStuskA48xklPh54wgLSwiagLvH59Q52EFtEwFii/+wsMJtZ4BiTREdnGYgtLKAh
	0XX9GmsXIwdQjabE/dYMiHI9iestf1lAwiwCqhKXb6iBhHkF7CWWz30LNkVIwEpiz6uPYMcx
	Ah33/dQaJojp4hLNrTdZII4WkFiy5zwzhC0q8fLxP7BNEgKKEttXW0GUa0ms33kcqlVb4sm7
	C6wQqwQlfky+xzKBUWwWkqmzkLTMQtIyC0nLAkaWVYxipcXJBcVJ6akVxnrFibnFpXnpesn5
	uZsYIXFXs4Px3lebQ4wCHIxKPLwvhB4ECrEmlhVX5h5ilOBgVhLh/W8IFOJNSaysSi3Kjy8q
	zUktPsTIxMEp1cDoY7VCmstc++u25Jzdvlca7tXZXvOtykoxdd7zpuCFVIbjtrb0ZIcJC130
	dvVWzA6fNcWjdW5LcW7BxUSuqb9zGC4XVkmbx95LzeELej6tUU15tcq+rl6zAovK1OoPxr/5
	j28uUL5/PK0t7U7y58tv6l94mW49NXX3OYsZnzOmM0uLJs98vlqJpTgj0VCLuag4EQAICIyt
	mQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 05:44 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.86 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Jul 13 22:18:05 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.86-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

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
