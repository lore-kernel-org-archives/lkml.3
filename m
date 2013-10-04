Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3JDAYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 20:24:11 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:32462 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3JDAYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 20:24:09 -0400
X-AuditID: cbfec37b-b7fa96d00000716e-cf-524e0aa81237
Message-id: <524E0AA5.3080604@samsung.com>
Date: Thu, 03 Oct 2013 18:24:05 -0600
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
Subject: Re: [ 00/16] 3.4.65-stable review
References: <20131003040445.523176877@linuxfoundation.org>
In-reply-to: <20131003040445.523176877@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hX90VXH5BBr39WhZz1q9hs2hevJ7N
	4vKuOWwWX386WCzY+IjR4lHfW3YHNo+ds+6ye5yY8ZvFY//cNewenzfJBbBEcdmkpOZklqUW
	6dslcGXs+e5ccJe34sjpJawNjG3cXYycHBICJhIX165ngbDFJC7cW8/WxcjFISSwjFFixozt
	TBBOL5PE/VMP2ECqhAQ2Mkr8mKINYvMKaEm83d3DBGKzCKhKLG1uZwex2QTUJT6/3sEOUS8n
	0bRkNTOILSoQIbFyyQNWiF5BiR+T74FtFhEwlug/OwusnlngGKPEwmYTEFsYaP6fx9tYIeZY
	SdzqOA1WwylgLfHx3n0WiHpriZWTtjFC2PISm9e8ZYaoV5b4c/kU0G0cQJ8pSmxfbTWBUWQW
	ks2zkHTPQtK9gJF5FaNYaXFyQXFSemqFkV5xYm5xaV66XnJ+7iZGSLxU72C8+9XmEKMAB6MS
	D69ArW+QEGtiWXFl7iFGCQ5mJRHe05+AQrwpiZVVqUX58UWlOanFhxiZODilGhijr109nHL/
	xV81m+zrx0LOFmtUFS4TnJ7ilXP3yfe2+1PKEvZlKZdYJmlHWL0zajQzWaFj0u7Zvu2yiJz5
	kse/v+nwlpWZFrb863OZvDgvdR3LRJu5D7hbns0zPZNZbK3JOk1+8ZEvD/YwsyQvkLT2/i2x
	cPfXu651cpk5yVMfrN6xy+z9x/tKLMUZiYZazEXFiQA/m5JBdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 10:05 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.65 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Oct  5 04:04:34 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.65-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch testing: 3.4.65-rc1-rc1 patch applied with white-space warnings 
and 3.4.65-rc2 applied cleanly.

Tested 3.4.65-rc1 and 3.4.65-rc2.
Compile testing: 3.4.65-rc1 and 3.4.65-rc2. Passed
Boot testing: 3.4.65-rc1 and 3.4.65-rc2. Passed
dmesg regression testing: passed. dmesgs look good. No regressions 
compared to the previous dmesgs for this release. dmesg emerg, crit, 
alert, err are clean. No regressions in warn.

Test systems

Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile
testing)

Cross-compile tests results

alpha 	defconfig 	Passed
arm 	defconfig 	Passed
arm64 	defconfig 	Not applicable
blackfin defconfig 	Passed
c6x 	dsk6455_defconfig 	Passed
mips 	defconfig 	Passed
mipsel 	defconfig 	Passed
powerpc wii_defconfig 	Passed
sh 	defconfig 	Passed
sparc 	defconfig 	Passed
tile 	tilegx_defconfig Passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
