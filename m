Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab3LKBtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:49:40 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:59380 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3LKBtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:49:36 -0500
X-AuditID: cbfec37b-b7f0c6d000002c99-f3-52a7c4afcc7d
Message-id: <52A7C4AB.1020803@samsung.com>
Date: Tue, 10 Dec 2013 18:49:31 -0700
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
Subject: Re: [PATCH 3.12 00/62] 3.12.5-stable review
References: <20131210080057.415644748@linuxfoundation.org>
In-reply-to: <20131210080057.415644748@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hX931R5YHGfy6J2gxZ/0aNovmxevZ
	LC7vmsNm8fWng8WCjY8YLR71vWV3YPPYOesuu8eJGb9ZPPbPXcPu8XmTXABLFJdNSmpOZllq
	kb5dAlfGu0O7mArOclbsef+MqYHxJHsXIyeHhICJxIpTsxghbDGJC/fWs3UxcnEICSxjlNiy
	r5kJwullkuj6uAzK2cgo8XLtcjaQFl4BLYmTV/eC2SwCqhJPTnaygthsAuoSn1/vAFshJCAn
	0bRkNTOILSoQIXF09TNWiF5BiR+T77GA2CICwRJrvy5kBFnALLCCUeL4y5dgQ4WB7ps88xgL
	xCAriRefZ4DFOQWsJT7M3AwWZwayV07axghhy0tsXvOWGaJeWeLP5VNAV3MA/aYosX211QRG
	kVlIVs9C0j0LSfcCRuZVjGKlxckFxUnpqRVGesWJucWleel6yfm5mxghUVO9g/HuV5tDjAIc
	jEo8vAeKlgcJsSaWFVfmHmKU4GBWEuHdaAoU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwCh38mR7
	/nmxTzL9i59X11xjlH608vAl35pLrB0FBlNbzZb9evDnfvZdpl22isfX/OXNMNl3TCQ60qBm
	i/SnK6fvTQ+e5nD73YLnBtIB+1gPr1P2nBwR1LR8P+OXW2dKji2/ZpDUFDFx1kHL+7HPumPj
	nU86+R70iMhbKlIiNSUl4pWK/IfTNpuUWIozEg21mIuKEwGFy/L+eAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 01:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.5 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Dec 12 08:00:42 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.5-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Patch applied cleanly
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
