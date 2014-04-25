Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaDYRCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:02:55 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:32841 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaDYRCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:02:51 -0400
X-AuditID: cbfec37a-b7fd76d000006048-76-535a953af13f
Message-id: <535A9537.1080709@samsung.com>
Date: Fri, 25 Apr 2014 11:02:47 -0600
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
Subject: Re: [PATCH 3.14 00/33] 3.14.2-stable review
References: <20140424214449.423169713@linuxfoundation.org>
In-reply-to: <20140424214449.423169713@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.8]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX12rqVHBBguPyljMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujDOn+hkLtrBV7HzwjrGBsYu1i5GTQ0LARKJ/4zQoW0ziwr31bF2M
	XBxCAssYJbY8vckC4fQySRx7+YwVwtnAKHF65TxGkBZeAS2Jj1tvsIHYLAKqEje2P2QBsdkE
	1CU+v97BDmILCchJNC1ZzQxiiwpESNxrPMwK0Sso8WPyPbB6EYFgibVfFzKCLGAWWMUocf3y
	crChwkD39U1+zAoxyEriwMQZTCA2p4C1xPF7+8GOYAayV07aBmXLS2xe85YZol5Z4s/lU0D1
	HEC/KUh87XGYwCgyC8nqWUi6ZyHpXsDIvIpRrLQ4uaA4KT21wlCvODG3uDQvXS85P3cTIySW
	qnYw3vlqc4hRgINRiYd3R05UsBBrYllxZe4hRgkOZiURXo4eoBBvSmJlVWpRfnxRaU5q8SFG
	Jg5OqQZG1xnM+2s0b37nZbzHmPXc+Y79h8OXJ0/Z9ke09aE71/3UJ3vdnL3bjoWdcb+wv6pR
	9EK/3QLNk+fWRj/IWvYgOv3nujjWbo7DC5M0hKbukdRJERaY8DT38dL3W5OLviV2/4857rX1
	TGm7054JeQcEz4grLWJc+176hcuSQylT8lNL7zr2KB7RV2Ipzkg01GIuKk4EACLurvGDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 03:48 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.2 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Apr 26 21:44:12 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.2-rc1.gz
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
