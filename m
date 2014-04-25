Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaDYRVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:21:37 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:9132 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaDYRVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:21:35 -0400
X-AuditID: cbfec37b-b7fc26d0000070ab-03-535a999da8d7
Message-id: <535A999A.2070806@samsung.com>
Date: Fri, 25 Apr 2014 11:21:30 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.4 00/27] 3.4.88-stable review
References: <20140424215551.942390050@linuxfoundation.org>
In-reply-to: <20140424215551.942390050@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.8]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9hP925M6OCDZa/ULCYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGTd+H2As2MBWsfXPJOYGxi7WLkZODgkBE4mWq+tYIGwxiQv31rN1
	MXJxCAksY5TYPPsqI0hCSKCXSWJ5bxJEYgOjxNW+2exdjBwcvAJaEp+vqYLUsAioSnxs+AU2
	lE1AXeLz6x3sEL1yEk1LVjOD2KICERL3Gg+D1fAKCEr8mHwPbLGIQLDE2q8LGUHmMwusYpS4
	fnk5G0hCWMBYYuXfqSwQg6wkLt1sBotzClhL9C9dDzaUWcBM4lHLOihbXmLzmrfMEPXKEn8u
	n2ICuVNCQEHia4/DBEaRWUhWz0LSPQtJ9wJG5lWMYqXFyQXFSempFUZ6xYm5xaV56XrJ+bmb
	GCFxVL2D8e5Xm0OMAhyMSjy8O3KigoVYE8uKK3MPMUpwMCuJ8HL0AIV4UxIrq1KL8uOLSnNS
	iw8xMnFwSjUw8s5tcHpwL/fM4pbLxw61Kd50/nXa9Gampke+x0fFf92C5xaHrb+QPbk9Ifxm
	TpFYoeqySQyi3hs9zCep+Vd0TPbaUhDTn/hi6YsMgRkvjh3d6M+zvydtY95Tqcj7n0OmFV3N
	2C7CZPGP/dg8Xqvp82I2CwhzbNu7kPnIuWSzXTLn19/ctdotRImlOCPRUIu5qDgRANIAA/qB	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 03:55 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.88 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Apr 26 21:55:41 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.88-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted. No dmesg regressions.

-- Shuah
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
