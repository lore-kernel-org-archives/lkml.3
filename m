Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3FLPt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:49:26 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:42234 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3FLPtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:49:24 -0400
X-AuditID: cbfec37b-b7f306d0000047de-f3-51b898835078
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/79] 3.9.6-stable review
Thread-topic: [ 00/79] 3.9.6-stable review
Thread-index: AQHOZu9tgHc9SW5lp0me396fcGKThA==
Date: Wed, 12 Jun 2013 15:49:22 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61568D7C@sisaex02sj>
References: <20130611195312.352656079@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+wr27zjB2BBhv7pCzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mo49vMoU8Ey/opDqz8wNzCe5Oli5OSQEDCR2PjoMBuELSZx4d56IJuLQ0hgGaPE9Cc/
	mCCcXiaJg02dzBDOfEaJW+cXsoK0sAmoS3x+vYMdxBYRMJboPzsLzGYWOMYk0dFZBmILC2hK
	/OruZIGo0ZI4ufkpK4StJ7F4+k4mEJtFQFVi/5RFYL28AvYST269B4sLCVhJ/F+9D+w8RqDz
	vp9awwQxX1yiufUmC8TZAhJL9pxnhrBFJV4+/gc0nwPIVpTYvtoKolxLYv3O41Ct2hJP3l1g
	hVglKPFj8j2WCYxis5BMnYWkZRaSlllIWhYwsqxiFCstTi4oTkpPrTDSK07MLS7NS9dLzs/d
	xAiJveodjHe/2hxiFOBgVOLhndC8I1CINbGsuDL3EKMEB7OSCK/DBKAQb0piZVVqUX58UWlO
	avEhRiYOTqkGRuF9u4Srdouf+GttufXK19pXhR0rwhV4mQU+uzsn3stVe3v9yRK5t3zbFKdl
	JAhNrVzUuiH11uHJ+0SVud4Hyl/ovDhPVVn/wI2uCU5lGyYm9MwuUuoSmrvQxrc/MktxyqHA
	vwvfJM9e05l64ukrxoWsYtpKe0K6svXXaF1byBYtEMNyZKKarBJLcUaioRZzUXEiALDXOKOb	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 04:02 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.9.6 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 13 19:50:17 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.6-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.81, 3.4.48, and 3.9.5

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.49-rc1, and 3.9.6-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.82-rc1, 3.4.49-rc1, and 3.9.6-rc1)

dmesgs for all releases look good. No regressions compared to the previous
dmesgs for each of these releases.

Reviewed patches.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.82-rc1, 3.4.48-rc1, and 3.9.6-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.9.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y and 3.9.y
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
