Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3LCV4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:56:41 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:29317 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab3LCV4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:56:39 -0500
X-AuditID: cbfec37c-b7f9d6d000003434-c7-529e53965c04
Message-id: <529E5393.1040401@samsung.com>
Date: Tue, 03 Dec 2013 14:56:35 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/60] 3.4.72-stable review
References: <20131202190330.152596462@linuxfoundation.org>
In-reply-to: <20131202190330.152596462@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP91pwfOCDO7P57aYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvjwLbLLAVHOCtubJjA2MC4h72LkZNDQsBE4uHaP1C2mMSFe+vZuhi5OIQEljFK3O66
	B+X0Mkn8arrOAuFsZJS4/HkXG0gLr4CWxJVt3SwgNouAqkTn6ztgNpuAusTn1zvAxgoJyEk0
	LVnNDGKLCkRIHF39jBWiV1Dix+R7YPUiAsESa78uZARZwCxwmFHi3P5rYEXCAsYSR35uZIIY
	ZCVxcstroKEcHJwC1hL/t7mBhJkFzCQetaxjhrDlJTavecsMUa4s8efyKSaQcgkBRYntq60m
	MIrMQrJ5FpLuWUi6FzAyr2IUKy1OLihOSk+tMNYrTswtLs1L10vOz93ECImZmh2M977aHGIU
	4GBU4uFN4JwXJMSaWFZcmXuIUYKDWUmEd6sfUIg3JbGyKrUoP76oNCe1+BAjEwenVAPjRG4T
	rWuJfxUWzrac9nL9bsOe7DlHmvXmSyUvrG0qCdwfWmSiqhDzQPTHJE71zKTF9ksZvxzfeKYx
	pbH6ldiHc9+vnD0VIxFUdaj9rlWJ7KEENr77LN3nEr7eOfJhwfIHR9RXNF+rPiywXDhWa9rN
	hFa1w7s+LheOeezTNY3zvPDuHRNErrR+VWIpzkg01GIuKk4EADEnSuh3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 12:05 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.72 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Dec  4 19:01:45 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.72-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch applied cleanly
compile and boot tests - passed
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
