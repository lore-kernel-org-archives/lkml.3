Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3GBSrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:47:11 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:57174 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab3GBSrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:47:09 -0400
X-AuditID: cbfec37d-b7f036d000004805-dd-51d3202b061c
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/26] 3.9.9-stable review
Thread-topic: [ 00/26] 3.9.9-stable review
Thread-index: AQHOdp82ygnwdhPD00a+ffzJBlDrAA==
Date: Tue, 02 Jul 2013 18:47:05 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61734339@sisaex02sj>
References: <20130701200729.872850414@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e+wr662wuVAg50blS3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MrYtWgDe0E7f8Wa/W+ZGhjX83QxcnBICJhIrNso2MXICWSKSVy4t54NxBYSWMYosXVi
	aRcjF5DdyySx+fJ0VghnPqPEje19YFVsAuoSn1/vYAexRQSMJfrPzgKzmQWOMUl0dJaB2MIC
	mhL3Jz1ng6jRkrjU/IwVwtaTmPVmOjPIESwCqhJzf4OV8ArYS8z4dhfqCCuJu1dvMILYjEDH
	fT+1hglivLhEc+tNFoijBSSW7DnPDGGLSrx8/I8V4i9Fie2rrSDKtSTW7zwO1aot8eTdBVaI
	VYISPybfY5nAKDYLydRZSFpmIWmZhaRlASPLKkax0uLkguKk9NQKE73ixNzi0rx0veT83E2M
	kKir3cF4/6vNIUYBDkYlHl6HZ5cChVgTy4orcw8xSnAwK4nwcgtfDhTiTUmsrEotyo8vKs1J
	LT7EyMTBKdXAONufl/lZjSK/Qczxe0z3kkzz5DQOXyub0CBs/PBObfa6SSw/Zb59vXu/uipu
	/p6PlrM/1TTemX3f85r1qb+XNn6vnT1NvenHmfh2o+xpDLMmmLGWP37yzXyWtEXyR4NTW9Sz
	PNLftDaLRJ4R5VxUF2EWIZf28ruyyHFdw8eTQp8XiU8J/H7qvRJLcUaioRZzUXEiAFBzqQyY	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 03:09 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.9.9 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jul  3 20:05:42 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.9-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

atches applied cleanly to 3.0.84, 3.4.51, and 3.9.8

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.52-rc1, and 3.9.9-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.85-rc1, 3.4.52-rc1, and 3.9.9-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.85-rc1, 3.4.52-rc1, and 3.9.9-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.9.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, and 3.9.y
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
