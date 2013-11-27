Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab3K0Wao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:30:44 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:47007 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601Ab3K0Wam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:30:42 -0500
X-AuditID: cbfec37d-b7fa86d000003175-88-52967291abc2
Message-id: <5296728F.4000103@samsung.com>
Date: Wed, 27 Nov 2013 15:30:39 -0700
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
Subject: Re: [PATCH 3.11 00/36] 3.11.10-stable review
References: <20131126181025.029404973@linuxfoundation.org>
In-reply-to: <20131126181025.029404973@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hP92JRdOCDH4+N7eYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSuj/aRLwSnuii3z2RsY53F2MXJySAiYSGy69p0JwhaTuHBvPVsXIxeHkMAyRokHl/cz
	Qzi9TBJTN/QwQTibGCX2LFrMDtLCK6Al8XjVTGYQm0VAVWJq7x6wOJuAusTn1zvAbCEBOYmm
	JavBakQFIiSOrn7GCtErKPFj8j0WEFtEIFhi7deFjCALmAVWMEocf/mSDSQhLGAqsa1lIyPE
	ICuJtml3wJo5Bawl1i7+AGYzA9krJ21jhLDlJTavecsMUa8s8efyKaCrOYB+U5TYvtpqAqPI
	LCSrZyHpnoWkewEj8ypGsdLi5ILipPTUChO94sTc4tK8dL3k/NxNjJCIqd3BeP+rzSFGAQ5G
	JR7eA5rTgoRYE8uKK3MPMUpwMCuJ8KrZA4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwzub9st6C
	8ZrDcV1PPjUhlSpnr2XSb+f3x25lijIIalpiknD5+cKERct0T1zImil427i28aPCwnlz1tgs
	e1q1fJ7q58vfpwqEf6oP/hnCfuLFx/vrtOfzbVjEmeV04fXv1W+nRNpLbFzyO3ybrtnJL1xd
	EpPmM/L9fp5mvW+DbFSJRttn+39fq5VYijMSDbWYi4oTAXGKJht2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 11:12 AM, Greg Kroah-Hartman wrote:
> ---------------------------------
> NOTE:
>    This is the LAST 3.11.x kernel I will be releasing.  Everyone should
>    be moving to the 3.12.x series at this point in time.  After this
>    kernel is released, 3.11 will be end-of-life.
> ---------------------------------
>
> This is the start of the stable review cycle for the 3.11.10 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Nov 28 18:08:16 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.10-rc1.gz
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
Cross-compile testing - didn't test this time.

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
