Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3KTP1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:27:00 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:41688 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab3KTP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:26:58 -0500
X-AuditID: cbfec37d-b7f0e6d00000657c-e7-528cd4c16ae5
Message-id: <528CD4BF.7020905@samsung.com>
Date: Wed, 20 Nov 2013 08:26:55 -0700
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
Subject: Re: [PATCH 3.11 00/25] 3.11.9-stable review
References: <20131118184032.248465920@linuxfoundation.org>
In-reply-to: <20131118184032.248465920@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX92DV3qCDD594baYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvj9KYmloJrXBUvnnezNDAe5ehi5OSQEDCRWHjjKROELSZx4d56ti5GLg4hgWWMEidu
	XGOGcHqZJNae280C4WxilLjz5hwzSAuvgJbEwda37CA2i4CqxNX3Z8DibALqEp9f7wCLCwnI
	STQtWQ0WFxWIkDi6+hkrRK+gxI/J91hAbBGBYIm1XxcygixgFljBKHH85Us2kIQw0H2nfi1m
	hRhkJfFk+gugQRwcnALWEhNP54KEmYHMlZO2MULY8hKb17xlhihXlvhz+RQTSLmEgKLE9tVW
	ExhFZiHZPAtJ9ywk3QsYmVcxipUWJxcUJ6WnVpjoFSfmFpfmpesl5+duYoTETO0OxvtfbQ4x
	CnAwKvHwFi7qDhJiTSwrrsw9xCjBwawkwtu1tydIiDclsbIqtSg/vqg0J7X4ECMTB6dUA2Oa
	3eNteYsevJ3w5fOEIlFJldBzKyvyNr7iDfg9/aFDuNAklol/j86rXjP5u5Yy2/6flmtz7P9f
	6bhvWxmxrZzPaH5obvbH72rKnT8Sjoot9HOO81rx/egXv/Jzx1/+nrab58TOCMcrt/cF6c1u
	PP5k4vVZa4TOCxsbxNbcTU0Sybmf0LJUIvqDEktxRqKhFnNRcSIApkLeh3cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 11:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.9 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Nov 20 18:40:06 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.9-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.11.9:

patches applied cleanly
Compile test - passed
Boot tests - passed

dmesg regression tests - passed
[dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.]

Cross-compile testing - limited tests passed (alpha, arm, arm64, 
blackfin, c6x, powerpc, sh, sparc, tile)

Test systems:
Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile testing)

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
