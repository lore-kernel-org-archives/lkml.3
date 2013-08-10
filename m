Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab3HJWHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 18:07:14 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:57863 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869Ab3HJWHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 18:07:12 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-71-5206b98ef686
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [ 000/102] 3.10.6-stable review
Thread-topic: [ 000/102] 3.10.6-stable review
Thread-index: AQHOlQgAW6aTot4E+kWIZH6aFkzVTw==
Date: Sat, 10 Aug 2013 22:07:08 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61762F0A@sisaex02sj>
References: <20130809015010.208118575@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E61761C23@sisaex02sj>
 <20130809191002.GC10130@kroah.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9hX92+nWxBBgcfC1jMWb+GzaJ58Xo2
	i8u75rBZLNj4iNHiUd9bdgdWjxMzfrN47J+7ht3j8ya5AOYoLpuU1JzMstQifbsEroxpG/tZ
	C2YKVlz58Za9gXE6XxcjB4eEgInE/dteXYycQKaYxIV769m6GLk4hASWMUp8mzmTFcLpZZJ4
	em4qC4Qzn1Hi4KwGNpAWNgF1ic+vd7CD2CICxhL9Z2exgxQxC8xkkvh/bAITSEJYQEfiyYG5
	UEW6EpNfX2IFWS0ioCexenI8SJhFQFXi1ey1jCA2r4C9xP1nn5ghlk1llHi49CkrSIIR6L7v
	p9aAzWQWEJdobr3JAnG3gMSSPeeZIWxRiZeP/7FCvKYosX21FUS5lsT6ncehWrUlnry7wAqx
	S1Dix+R7LBMYxWYhmToLScssJC2zkLQsYGRZxShWWpxcUJyUnlphrFecmFtcmpeul5yfu4kR
	Emk1OxjvfbU5xCjAwajEw9u4ji1IiDWxrLgy9xCjBAezkghveyVQiDclsbIqtSg/vqg0J7X4
	ECMTB6dUA6Op5/6/Z3SWSxvdX+3xryTpr5hf42Teg5+elLW7PP2/fMa5wPlPXqvk3rnkEeL5
	9eWbY2zF0cE/fH0y1r+WkI6+1P3GWGdRqoFs0n3/6SE73ri2nlcIuj8v3/XKx5aW/XMYlaoa
	7jD/8j24cp72Qu/pr25MuSSnY6a8Vu3KV5E5cdcvR7/l4g1SYinOSDTUYi4qTgQAAhrIV5IC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 01:10 PM, Greg Kroah-Hartman wrote:
> On Fri, Aug 09, 2013 at 02:42:24PM +0000, Shuah Khan wrote:
>> On 08/09/2013 07:54 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.10.6 release.
>>> There are 102 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun Aug 11 01:46:31 UTC 2013.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>

Patches applied to 3.0.89, 3.4.56 and 3.10.5

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.57-rc1, 3.10.6-rc1)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.90-rc1, 3.4.57-rc1, and 3.10.6-rc1)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.90-rc1, 3.4.57-rc1, and 3.10.6-rc1)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.10.y
blackfin: defconfig passed on all
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
