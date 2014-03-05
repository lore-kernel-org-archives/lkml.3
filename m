Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaCEWbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:31:00 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:64701 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaCEWa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:30:57 -0500
X-AuditID: cbfec37d-b7f616d0000059df-4d-5317a59fd3c3
Message-id: <5317A59D.4060201@samsung.com>
Date: Wed, 05 Mar 2014 15:30:53 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13 000/172] 3.13.6-stable review
References: <20140304200259.626667112@linuxfoundation.org>
In-reply-to: <20140304200259.626667112@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.11]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX935S8WDDZZ/trCYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSvj2qY7zAUN7BVr925ibmA8wdrFyMkhIWAicXf+NShbTOLCvfVsXYxcHEICyxglTk+6
	COX0MkmcmjibGcLZxCixdOcnZpAWXgEtica+V4xdjBwcLAKqEv//FICE2QTUJT6/3sEOYgsJ
	yEk0LVkNVi4qECHx6uxEFohWQYkfk++B2SICwRJrvy5kBJnPLLCCUeL4y5dsIAlhATOJpr6D
	TBCDrCSevJ8BZnMKWEtc7L4PdjYzUM2jlnXMELa8xOY1b5kh6pUl/lw+xQRym4SAosSv/+4T
	GEVmIVk9C0n3LCTdCxiZVzGKlRYnFxQnpadWmOgVJ+YWl+al6yXn525ihMRM7Q7G+19tDjEK
	cDAq8fBu8BMPFmJNLCuuzD3EKMHBrCTCGxAJFOJNSaysSi3Kjy8qzUktPsTIxMEp1cCotrv6
	6K+UoF+K1e+/aC1mPr/F5/uMqaqeCdkpntqPL76wmKa5zErS89bml9Jvd7zPYFY5+PjHej/1
	xqfmXRd5f5rodn8TX6gmKnttj4S2x4e9wut+iz7KF90W7/qTtdpkc4jNr4iHW7ZPiYiSDq1d
	KmrwMFrN1tedwWyH81YGB37+df4XHjgrsRRnJBpqMRcVJwIAOSZIrHcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 01:01 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.13.6 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Mar  6 20:02:29 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.6-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compile tests and boot tests passed. No dmesg regressions: emerg, crit, 
alert, err are clean. No regressions in warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
