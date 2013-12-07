Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab3LGWPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 17:15:32 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:32092 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3LGWP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 17:15:28 -0500
X-AuditID: cbfec37b-b7fef6d0000049cb-b0-52a39dff4e99
Message-id: <52A39DF5.2060803@samsung.com>
Date: Sat, 07 Dec 2013 15:15:17 -0700
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
Subject: Re: [PATCH 3.12 00/83] 3.12.4-stable review
References: <20131206214640.002320724@linuxfoundation.org>
In-reply-to: <20131206214640.002320724@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP93/cxcHGdz6z2UxZ/0aNovmxevZ
	LC7vmsNm8fWng8WCjY8YLR71vWV3YPPYOesuu8eJGb9ZPPbPXcPu8XmTXABLFJdNSmpOZllq
	kb5dAlfGwy/bGAvOclac2KTZwHiSvYuRk0NCwERi9sv5jBC2mMSFe+vZuhi5OIQEljFKtH08
	xQ7h9DJJfPmwgwnC2cQo8eLodiaQFl4BLYnjO6+C2SwCqhIzjmxhBrHZBNQlPr/eAbZCSEBO
	omnJarC4qECExNHVz1ghegUlfky+xwJiiwgES6z9upARZAGzwApGieMvX7KBJISB7pt/fTcb
	xCArifatG8AaOAWsJd48OQRmMwuYSTxqWccMYctLbF7zlhmiXlniz+VTQMdxAP2mKLF9tdUE
	RpFZSFbPQtI9C0n3AkbmVYxipcXJBcVJ6akVRnrFibnFpXnpesn5uZsYITFTvYPx7lebQ4wC
	HIxKPLwVFouChFgTy4orcw8xSnAwK4nwht8ECvGmJFZWpRblxxeV5qQWH2Jk4uCUamC03Pr5
	+/n958LFjRMD1rXu2fvKcZJvavOVf5VlKpfK3Zq31nZuOCvON5tVJNPqxqXju8UDJQMiEz5y
	SQQGaXU53JH4ovl7Y983M3Or3fV86+dNY2X1nBaj+bk6+nRGuVRaWEP97eXTU5+ITl/vIWbD
	e5b30Zp68W0xDu0hmoveHtS+t21SwgwlluKMREMt5qLiRAAzYFPPdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 02:50 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.4 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Dec  8 21:44:41 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.4-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

patch applied cleanly.
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
