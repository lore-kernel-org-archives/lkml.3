Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab3K0W3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:29:19 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:46921 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab3K0W3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:29:17 -0500
X-AuditID: cbfec37c-b7f9d6d000003434-5e-5296723b44e7
Message-id: <52967239.4060705@samsung.com>
Date: Wed, 27 Nov 2013 15:29:13 -0700
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
Subject: Re: [PATCH 3.4 00/39] 3.4.71-stable review
References: <20131127005619.011763867@linuxfoundation.org>
In-reply-to: <20131127005619.011763867@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP13romlBBm17bCzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MqYOHMCc8FazooTK84yNjDuZu9i5OSQEDCRWHDtExuELSZx4d56IJuLQ0hgGaPE44Vz
	oJxeJonlnbcYIZxNjBLHD3wDa+EV0JK4dHc7K4jNIqAqMe/DV7A4m4C6xOfXO8BWCAnISTQt
	Wc0MYosKREgcXf2MFaJXUOLH5HssILaIQLDE2q8LwRYwC6wAWvDyJdggYQFjiZ3zTgElOIAG
	WUnsfOcJEuYUsJa4t/0/2ExmIHvlpG2MELa8xOY1b5kh9ipL/Ll8igmkVUJAUWL7aqsJjCKz
	kGyehaR7FpLuBYzMqxjFSouTC4qT0lMrjPWKE3OLS/PS9ZLzczcxQmKmZgfjva82hxgFOBiV
	eHgPaE4LEmJNLCuuzD3EKMHBrCTCq2YPFOJNSaysSi3Kjy8qzUktPsTIxMEp1cCYMOOk+DQH
	i90p3KHVk5uPXUk907Fl2dbeXSeX/vq5REJJ52SlmZD1x/uXj9oU2XAcvyi05/BLp2C36Mj6
	4EermPTP3Nsa3KV9t+bfwpNF12TUBfZpR2jGrD69xzjp97zT6/4rbA08f2Wand2hxfGvHb6F
	ZAvuXL1x8+I/6xawvjzfLhibeu/wFSWW4oxEQy3mouJEABxjV6Z3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 05:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.71 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Nov 29 00:56:06 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.71-rc1.gz
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
