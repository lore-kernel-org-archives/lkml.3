Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422669AbaDJT4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:56:37 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:63797 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaDJT4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:56:34 -0400
X-AuditID: cbfec37a-b7fc06d00000555a-f9-5346f771292b
Message-id: <5346F76D.8030704@samsung.com>
Date: Thu, 10 Apr 2014 13:56:29 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.4 000/134] 3.4.87-stable review
References: <20140410032259.587501440@linuxfoundation.org>
In-reply-to: <20140410032259.587501440@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.250]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX93C727BBhcXsVvMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujJ/TWxgLVrNVzL+0iLWBsYO1i5GTQ0LARGJbxzoWCFtM4sK99Wxd
	jFwcQgLLGCUmddxlA0kICfQySbz/6A+R2MYosWTvarBuXgEtiQUzZ4HZLAKqEjPPbQFrYBNQ
	l/j8egc7RLOcRNOS1cwgtqhAhMSrsxNZIHoFJX5MvgdmiwgES6z9upARZAGzwCpGieuXl4MN
	EhYwlbh34y8rxCAriVUn/4DFOQWsJa52NDGC2MxA9spJ26BseYnNa94yQ9QrS/y5fIoJ4jVl
	iY2H3rFMYBSZhWT3LCTts5C0L2BkXsUoVlqcXFCclJ5aYahXnJhbXJqXrpecn7uJERJLVTsY
	73y1OcQowMGoxMN74JJbsBBrYllxZe4hRgkOZiURXtn3QCHelMTKqtSi/Pii0pzU4kOMTByc
	Ug2MWlsc3B12r/vZ13lkb3/5hC/fo4wL41LPuq9wvsdwpfCY5YvbXfunXT/2zyqgdi5DUWvy
	3fl9c840NJrLy1TVNhcWVdoHBKxvi62UttnZdO2S5Zek73KuUsEn3J8bqVsq6uiXK/7mc5z1
	rPLt/Qj+2JcnCr6td/g5JbqJvaZtJeOuw9bqv+8osRRnJBpqMRcVJwIA4Xy6GIMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 09:21 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.87 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Apr 12 03:22:28 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.87-rc1.gz
> and the diffstat can be found below.
>

Compiled and booted on my test systems. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
