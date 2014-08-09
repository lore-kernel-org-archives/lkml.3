Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaHIOmD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:42:03 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:58633 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaHIOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:42:00 -0400
X-AuditID: cbfec37d-b7f676d000000907-f5-53e6333663cf
Message-id: <53E63334.6020903@samsung.com>
Date: Sat, 09 Aug 2014 08:41:56 -0600
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
Subject: Re: [PATCH 3.10 00/24] 3.10.53-stable review
References: <20140808213335.421758947@linuxfoundation.org>
In-reply-to: <20140808213335.421758947@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.217]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t9hP10z42fBBgu36lvMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujOYJ25gKjrFVvJrA28A4i7WLkYNDQsBEomt6ShcjJ5ApJnHh3nq2
	LkYuDiGBZYwSX5ftZodwepkkNi68zwpSJSSwjVGif1kiSDOvgJbEh7uxIGEWAVWJpklb2UFs
	NgF1ic+vd7BDlMtJNC1ZzQxiiwpESBzoewY2hldAUOLH5HssILaIQLDE2q8LGUF2MQusYpS4
	fnk5G0hCWMBUYsHmrVCDrCQ+7PkD1sApYC1x4GQXWA0zkL1y0jZGCFteYvOat8wQ9coSfy6f
	YoL4TFni/uSDLBMYRWYh2T0LSfssJO0LGJlXMYqVFicXFCelp1aY6BUn5haX5qXrJefnbmKE
	RFHtDsb7X20OMQpwMCrx8K6weRosxJpYVlyZe4hRgoNZSYT3hPqzYCHelMTKqtSi/Pii0pzU
	4kOMTBycUg2M63clmqR/OxCpO9lH9qfF88yimZ0LVB7/zPz15L/gNPu82M0Wnpd5Jqy+e5xB
	+OgP5oKNN+dllESesCy0mz1rb5pPf7WX0fGghLL30ziyFVd8yDylfPb1VW6GPQecXofpT+62
	Ps1nEurw4021gPCuWUbPe628f/db/jgzO7zFfcLEB/xvV6xmVGIpzkg01GIuKk4EAB3V76yA	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 03:34 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.53 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug 10 21:33:26 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.53-rc1.gz
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
