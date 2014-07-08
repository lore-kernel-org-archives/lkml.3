Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492AbaGHTb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:31:29 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8870 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbaGHTbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:31:24 -0400
X-AuditID: cbfec37d-b7fbf6d000005712-48-53bc470ccb37
Message-id: <53BC4709.7000907@samsung.com>
Date: Tue, 08 Jul 2014 13:31:21 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.14 00/94] 3.14.12-stable review
References: <20140707235756.780319003@linuxfoundation.org>
In-reply-to: <20140707235756.780319003@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.209]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t9hX10e9z3BBvM3clrMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujJ7dF9gKjrFV3JxxgLmBcSZrFyMHh4SAicS+l1JdjJxAppjEhXvr
	2boYuTiEBJYxSux+9oUNJCEk0Mskce9MJERiG6PE3h1PmEASvAJaEk23e8CKWARUJXZ27WIG
	sdkE1CU+v97BDtEsJ9G0ZDVYXFQgQuJA3zNWiF5BiR+T77GA2CICwRJrvy5kBFnALLCKUeL6
	5eVgQ4UFTCXmXVjMAnKpkICVxI6lYSAmp4C1xP21mSAVzAJmEo9a1jFD2PISm9e8ZYZYqyzx
	5/IpJojHlCUmNt5mmcAoMgvJ5llI2mchaV/AyLyKUay0OLmgOCk9tcJErzgxt7g0L10vOT93
	EyMkimp3MN7/anOIUYCDUYmH9wTnnmAh1sSy4srcQ4wSHMxKIrzLBYFCvCmJlVWpRfnxRaU5
	qcWHGJk4OKUaGGeIGwYvcp/Ix/r0oF7u/WeBv189m9C33DS6Xixo4/bSWWkTStcbR8cXlv55
	7+j+SudwSaT+IudUASHdxScX3lAPcpApiRNseXg2kaFsfYrazLiToR9MIrLYvSv7nt19uvHY
	/Z3b1CwfK4Q/CH5Q+M14po98ef99rsvr/x+4f+vetabOxRNtypRYijMSDbWYi4oTAQRlexaA	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 05:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.12 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jul  9 23:57:44 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.12-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system. No demsg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
