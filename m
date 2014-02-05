Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbaBEUk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:40:26 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:22517 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbaBEUkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:40:21 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-eb-52f2a1b369a9
Message-id: <52F2A1B1.7000004@samsung.com>
Date: Wed, 05 Feb 2014 13:40:17 -0700
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
Subject: Re: [PATCH 3.10 000/104] 3.10.29-stable review
References: <20140204210222.731641778@linuxfoundation.org>
In-reply-to: <20140204210222.731641778@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX90tCz8FGRybyWQxZ/0aNovmxevZ
	LC7vmsNm8fWng8WCjY8YLR71vWV3YPPYOesuu8eJGb9ZPPbPXcPu8XmTXABLFJdNSmpOZllq
	kb5dAlfG6+2LGAumc1Rc//mHrYHxIFsXIyeHhICJxIvG5VC2mMSFe+vBbCGBZYwSjzvCuxi5
	gOxeJonDbSsYIZwNjBI35vwFq+IV0JJY9morE4jNIqAqcaa5iwXEZhNQl/j8egc7xCQ5iaYl
	q5lBbFGBCIlXZyeyQPQKSvyYfA/MFhEIllj7dSHYAmaBFYwSx1++BFrAwSEsYC7xYFssxBwr
	ieb1txlBbE4Ba4lru9+B9TILmEk8alnHDGHLS2xe85YZol5Z4s/lU0wQnylIrLjxhmUCo8gs
	JKtnIWmfhaR9ASPzKkax0uLkguKk9NQKY73ixNzi0rx0veT83E2MkJip2cF476vNIUYBDkYl
	Hl6HGZ+ChFgTy4orcw8xSnAwK4nwnpgOFOJNSaysSi3Kjy8qzUktPsTIxMEp1cAo7q7OEN+Z
	wjlfcJ50zupra9Yntfp+2PjgfqP5/j8nsnkNlhQuiLH1fr5sdU4xc4PYvIKmgK6wxf/tbnZu
	ntatY/Sr1HdVZ/GXtV0B2WI7xfOFzhmVGOr0VYoVpuveKancU/aQbXnOJJkFn17wM39mrnad
	9mrKqxPxK5fKJLoJ/gi982Qhn50SS3FGoqEWc1FxIgCT2IsNdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 02:01 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.29 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Feb  6 21:02:03 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.29-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch applied cleanly. boot tests passed on all test systems. No dmesg 
regressions: emerg, crit, alert, err are clean. No regressions in warn.

Minor Note: git apply --index complained about extra white space at the 
end of patch file. patch -p1 worked just fine.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
