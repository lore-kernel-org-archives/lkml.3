Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab3LKBuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:50:13 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:16503 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3LKBuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:50:11 -0500
X-AuditID: cbfec37b-b7f0c6d000002c99-17-52a7c4d20ac2
Message-id: <52A7C4D0.3090707@samsung.com>
Date: Tue, 10 Dec 2013 18:50:08 -0700
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
Subject: Re: [PATCH 3.10 00/52] 3.10.24-stable review
References: <20131210075954.196229872@linuxfoundation.org>
In-reply-to: <20131210075954.196229872@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hP91LR5YHGazYKmcxZ/0aNovmxevZ
	LC7vmsNm8fWng8WCjY8YLR71vWV3YPPYOesuu8eJGb9ZPPbPXcPu8XmTXABLFJdNSmpOZllq
	kb5dAlfGm66djAXnOCt+v5/I1MB4hr2LkZNDQsBEovfVcmYIW0ziwr31bF2MXBxCAssYJfYu
	m8kK4fQySZxctwjK2cgocenVAlaQFl4BLYnLx9+xgNgsAqoSi9p72EBsNgF1ic+vd4CtEBKQ
	k2hashpshahAhMTR1c+gegUlfky+B9YrIhAssfbrQkaQBcwCKxgljr98CTZIWMBUYtupD8wQ
	g6wk7l3bwAhicwpYSxw4tBmshhnIXjlpGyOELS+xec1bqHpliT+XTzF1MXIA/aYosX211QRG
	kVlIVs9C0j0LSfcCRuZVjGKlxckFxUnpqRVGesWJucWleel6yfm5mxghUVO9g/HuV5tDjAIc
	jEo8vAeKlgcJsSaWFVfmHmKU4GBWEuHdaAoU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBhf7Ojj
	ECbgnybZl9xhu06O5aTdH525P71D1209Z52jUnBM1DppOp/sCofHH7jkfl/vvnu0UbXrcLtw
	i/7jvp1+C5bP8mx98b2m+LAU+9E76uF3tCYXf1ki+bVIPSFXRefX+lmHF8don7n88vfadyq3
	ImpvvZzvFjRX9/7M58X7RcoV5idprFZiKc5INNRiLipOBADV+CCYeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 01:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.24 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Dec 12 07:59:40 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.24-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
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
