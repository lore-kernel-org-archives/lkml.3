Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3FLPuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:50:44 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:42273 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3FLPun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:50:43 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-77-51b898d2c6a2
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/21] 3.0.82-stable review
Thread-topic: [ 00/21] 3.0.82-stable review
Thread-index: AQHOZwm5FV1/7A+SOE+BsWlPqiVJVQ==
Date: Wed, 12 Jun 2013 15:50:41 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61568D8B@sisaex02sj>
References: <20130611195520.003233586@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+wn+6lGTsCDZbvk7WYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvjxzzBghX8FVOWtbM2MJ7m6WLk5JAQMJH4e+oEK4QtJnHh3nq2LkYuDiGBZYwSt480
	MkI4vUwSF2cvYodw5jNKbDmxF6yFTUBd4vPrHewgtoiAsUT/2VlgNrPAMSaJjs4yEFtYQEvi
	5LYnzBA12hLb1j1ggrD1JH5O6gWbwyKgKvH943SwOK+AvUTPge1A9RxAy6wkNhyoAwkzAl33
	/dQaJojx4hLNrTdZIK4WkFiy5zwzhC0q8fLxP1aQVgkBRYntq60gyrUk1u88DtWqLfHk3QVW
	iE2CEj8m32OZwCg2C8nUWUhaZiFpmYWkZQEjyypGsdLi5ILipPTUCkO94sTc4tK8dL3k/NxN
	jJC4q9rBeOerzSFGAQ5GJR7eCc07AoVYE8uKK3MPMUpwMCuJ8DpMAArxpiRWVqUW5ccXleak
	Fh9iZOLglGpgFLh8n+GiYW+kmMT8N94cnh5n9Nd2iZav18/fvJ4lrLY7M2/XFN967d/v1X+G
	mLrOaLb/l/XJMqSm00gjTIYxY1qOSun6J81BEQoLOb4vmOpUu/VMt9j0ytqAFBYhtX3njfa8
	6Gjhe+Qz60v+ykJ/9s+G7kJF6nu8LbxZvmX8iVyVY/HyVocSS3FGoqEWc1FxIgAUFaR/mQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 07:11 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.82 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 13 19:52:33 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.82-rc1.gz
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
