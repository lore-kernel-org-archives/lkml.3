Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaBTAQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:16:29 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:36012 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaBTAQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:16:25 -0500
X-AuditID: cbfec37d-b7ff46d000005528-c5-530549588c05
Message-id: <53054956.4010602@samsung.com>
Date: Wed, 19 Feb 2014 17:16:22 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, broonie@linaro.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13 00/40] 3.13.4-stable review
References: <20140218224433.337299968@linuxfoundation.org>
In-reply-to: <20140218224433.337299968@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hX90IT9Zgg009+hZz1q9hs9h0/Tqr
	RfPi9WwWl3fNYbP4+tPBYsHGR4wWj/resjuwe+ycdZfd4861PWweJ2b8ZvHYP3cNu8fnTXIB
	rFFcNimpOZllqUX6dglcGXv2HWIvWMVVcbjvA2sD43yOLkZODgkBE4lVcz4wQthiEhfurWfr
	YuTiEBJYxijx//AtJginl0mi+cpXZghnA6PE3dUbWUFaeAW0JNYdPQ5mswioStzungE2ik1A
	XeLz6x3sILaQgJxE05LVzCC2qECExKuzE1kgegUlfky+B2aLCKRLLPq3ggVkAbPACkaJ4y9f
	soEkhIHuu/PzEVCCA2iQlcS71xUgYU4Ba4mFp1+C7WUGsldO2sYIYctLbF7zlhlir7LEn8un
	mCBeU5C4sXAZ6wRGkVlIVs9C0j4LSfsCRuZVjGKlxckFxUnpqRUmesWJucWleel6yfm5mxgh
	kVS7g/H+V5tDjAIcjEo8vBHXWYKFWBPLiitzDzFKcDArifBGs7EGC/GmJFZWpRblxxeV5qQW
	H2Jk4uCUamD0Xb43cVvKS3eRhDSu05dEgzZOe/BOWEz9Hf/0PRtE0/Yr2Ju6hloGvzcW3lu5
	6DLDoxT1yebJP/J6GhNX3RCI/i9Y+86sV3KHpM6j0C97FjZZ13/qWXJx+ZGtk5w9Z8XOtW9T
	27jzhdfV9AU/Utc5eZ9vvf4qRyDo75ELfudYz+QHvP7qcK9UiaU4I9FQi7moOBEAY/TWi4IC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 03:47 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.13.4 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Feb 20 22:44:22 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.4-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compile tests and boot tests passed.

On Intel systems, there are no dmesg regressions: emerg, crit, alert, 
err are clean. No regressions in warn.

On AMD systems, the following new error messages - suspect is to 
drivers/regulator/core.c - patch

3.13.4 - amd:
 > sdhci-pci 0000:02:00.1: dummy supplies not allowed
 > sdhci-pci 0000:02:00.1: dummy supplies not allowed
drivers/regulator/core.c - patch

Mark Brown <broonie@linaro.org>
     regulator: core: Correct default return value for full constraints

Is this a problem???

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
