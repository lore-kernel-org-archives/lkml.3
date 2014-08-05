Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaHEXIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:08:55 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:32372 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaHEXIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:08:53 -0400
X-AuditID: cbfec37d-b7f676d000000907-51-53e1640402ad
Message-id: <53E16401.20207@samsung.com>
Date: Tue, 05 Aug 2014 17:08:49 -0600
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
Subject: Re: [PATCH 3.4 00/19] 3.4.102-stable review
References: <20140805182934.022406678@linuxfoundation.org>
In-reply-to: <20140805182934.022406678@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hP12WlIfBBv+3aVrMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujJ337jIVPGaruPD1I0sD40bWLkZODgkBE4nJL2axQNhiEhfurWcD
	sYUEljFK3PrD1MXIBWT3MklcmXeBFcLZwCjxdHEDM0gVr4CGxOpv28C6WQRUJWbOegvWzSag
	LvH59Q52iElyEk1LVoPViwpESBzoe8YK0Sso8WPyPbBeEYFgibVfFzKCLGAWWMUocf3ycrBB
	wkDndfy5zQgxyEpi+ZlPYA2cAtYSv+fMAVvADGSvnLSNEcKWl9i85i0zRL2yxJ/Lp5ggXlOQ
	eHS1lX0Co8gsJLtnIWmfhaR9ASPzKkax0uLkguKk9NQKE73ixNzi0rx0veT83E2MkFiq3cF4
	/6vNIUYBDkYlHt4M04fBQqyJZcWVuYcYJTiYlUR4t8QDhXhTEiurUovy44tKc1KLDzEycXBK
	NTDO0Vkz5V9Ww16Ljv/vPfo7+XY0CTEzTXG/wJ8w30JBYWuN65O8+im2G2KbI0WMEl63791i
	pGz1qfVHdGt0+vupups1Yu/K7rI6GHfcz3dO7OPFs6/3TQ36IPGXwWeTWzFHIPPWdtPzTFc/
	zuYrPZrVNJkpeuL6aeqHjq/9V/Ag2+TGm6AJP3cqsRRnJBpqMRcVJwIAcDK8z4MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 12:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.102 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug  7 18:29:24 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.102-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system. No dmesg regressions
compared to previous 3.4.101

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
