Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaBEUiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:38:46 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:24655 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaBEUik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:38:40 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-07-52f2a14f0116
Message-id: <52F2A14C.6050505@samsung.com>
Date: Wed, 05 Feb 2014 13:38:36 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/37] 3.4.79-stable review
References: <20140204210055.992134150@linuxfoundation.org>
In-reply-to: <20140204210055.992134150@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hP13/hZ+CDKau5rSYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugStj96qgghnsFV2X+1kaGO+wdjFyckgImEgseHCTHcIWk7hwbz0biC0ksIxR4kNLDITd
	yyRxcUsWhL2BUaLzFD+IzSugJXFhQgNYPYuAqsTD3pdgNpuAusTn1zvYIerlJJqWrGYGsUUF
	IiRenZ3IAtErKPFj8j0wW0QgWGLt14WMXYxcHMwChxklzu2/BnacsICxxLSWNawQg6wkFi39
	DWZzClhLTP71jAnEZhYwk3jUso4ZwpaX2LzmLTNEvbLEn8unmCAeU5BYceMNywRGkVlIds9C
	0j4LSfsCRuZVjGKlxckFxUnpqRVGesWJucWleel6yfm5mxgh8VK9g/HuV5tDjAIcjEo8vAZd
	n4KEWBPLiitzDzFKcDArifCemA4U4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBhdld17e31WnmDS
	o4tmBuebXFbLX+S2fD6Pay3zC74vlTsfi33vW1S2SENMTSr7kOT65oQ+oQKuN7fF52s4W3xd
	Uyz6R8Z9v/99D7Y9CVdO3vC7mcFyaLmSaUD7bf+Vfs68CQ+u3P177kXS8mDRxy8Xud8Mtz17
	8NbB+dz3zRhufFh4/Wxr8HwlluKMREMt5qLiRACcNsT2dQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 02:00 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.79 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Feb  6 21:00:31 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.79-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch applied cleanly. boot tests passed on all test systems. No dmesg 
regressions: emerg, crit, alert, err are clean. No regressions in warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
