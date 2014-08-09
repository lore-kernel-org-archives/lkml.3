Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaHIOmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:42:39 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:14439 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaHIOmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:42:37 -0400
X-AuditID: cbfec37a-b7f216d000000635-24-53e6335c12e5
Message-id: <53E6335A.50604@samsung.com>
Date: Sat, 09 Aug 2014 08:42:34 -0600
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
Subject: Re: [PATCH 3.15 00/26] 3.15.10-stable review
References: <20140808213413.648794968@linuxfoundation.org>
In-reply-to: <20140808213413.648794968@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.217]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hP90Y42fBBhefGVrMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujJWTX7AWnGCr2Pr1G2sD4yzWLkZODgkBE4mrZ6+xQ9hiEhfurWfr
	YuTiEBJYxiix+ddbZginl0liXXsLVGYbo8TDRX1AGQ4OXgENibl3REC6WQRUJVo+XWIBsdkE
	1CU+v94BNlVIQE6iaclqZhBbVCBC4kDfM7DNvAKCEj8m3wOrFxEIllj7dSEjyHxmgVWMEtcv
	L2cDSQgLmErc3/mUDWKQlcSUM4vBBnEKWEss+vaZEcRmBrJXTtoGZctLbF7zlhmiXlniz+VT
	TBCvKUvcn3yQZQKjyCwku2chaZ+FpH0BI/MqRrHS4uSC4qT01ApDveLE3OLSvHS95PzcTYyQ
	WKrawXjnq80hRgEORiUe3hU2T4OFWBPLiitzDzFKcDArifCeUH8WLMSbklhZlVqUH19UmpNa
	fIiRiYNTqoExvDes7/uBgujJipIRPcb/lzYx7P42dwrnqvvGP9lZ5mWme6tNXjIzOmhTrmXc
	j4o9pzreMn8Uf7BSsPrOwtCXx34tu/nVJ+vokezZZolXNb/Lzb/zqel8pdINlz+sb28YL3y+
	90WHy9LLHG0aZudeRF1PzpUN2/9x3YOXMTGR1x68nrp5y8cf+UosxRmJhlrMRcWJAMW8zmqD	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 03:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.15.10 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug 10 21:34:03 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.10-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
