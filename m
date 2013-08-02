Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3HBT7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:59:51 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:61308 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab3HBT7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:59:49 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-bd-51fc0fb4efdb
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/23] 3.0.89-stable review
Thread-topic: [ 00/23] 3.0.89-stable review
Thread-index: AQHOj5J9Dr24jrog6EmxumSK5HHLcQ==
Date: Fri, 02 Aug 2013 19:59:47 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61756645@sisaex02sj>
References: <20130802102036.180660415@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e+wn+5W/j+BBld5LOasX8Nm0bx4PZvF
	5V1z2Cy+/nSwWLDxEaPFo7637A5sHjtn3WX3ODHjN4vH/rlr2D0+b5ILYInisklJzcksSy3S
	t0vgyli2cDtLwSX+iv9HDjM2ML7j6WLk5JAQMJFYdWgtE4QtJnHh3nq2LkYuDiGBZYwSOy5s
	YYFwepkkdu5/wAJSJSQwn1Fi/fUCEJtNQF3i8+sd7CC2iICxRP/ZWWA2s8AxJomOzrIuRg4O
	YQEtiRdHEiBKtCVmTFnMBhIWEdCTWHKAFSTMIqAq8WnJQTYQm1fAXmLe5h+MEJusJOY23WMG
	sRmBbvt+ag0TxHRxiebWmywQNwtILNlznhnCFpV4+fgfK8h4CQFFie2rrSDKtSTW7zwO1aot
	8eTdBVaIVYISPybfY5nAKDYLydRZSFpmIWmZhaRlASPLKkax0uLkguKk9NQKY73ixNzi0rx0
	veT83E2MkJir2cF476vNIUYBDkYlHt4Hmb8ChVgTy4orcw8xSnAwK4nwLnz2O1CINyWxsiq1
	KD++qDQntfgQIxMHp1QDo4qnU8arXckXLvxV3MBaoKrls8T0xzqb6B6xlt+W1yU2/mxc6uP8
	1foJy9zbgv9V1NYHOvDcM+9/kqc9j70rRt/QVEZ9p/77+3PnRd9hy5zKlivmInDvYziDx56I
	sqDrO2yV3/W7H+VbH8QptuviAt1P+/ZwlFUGLl/21X2XhGLr4zrHeQeuK7EUZyQaajEXFScC
	AC7/cDuXAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 09:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.89 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug  4 10:19:28 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.89-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.88, 3.4.55 and 3.10.4

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.56-rc1, 3.10.5-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.89-rc1, 3.4.56-rc1, and 3.10.5-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.89-rc1, 3.4.56-rc1, and 3.10.5-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.10.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, and 3.10.y
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
