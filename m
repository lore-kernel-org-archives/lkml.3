Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213AbaE3Tho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:37:44 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:16581 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbaE3Thm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:37:42 -0400
X-AuditID: cbfec37c-b7fd06d000004f49-17-5388de041276
Message-id: <5388DDFB.705@samsung.com>
Date: Fri, 30 May 2014 13:37:31 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.12 000/103] 3.12.21-stable review
References: <cover.1401371258.git.jslaby@suse.cz>
In-reply-to: <cover.1401371258.git.jslaby@suse.cz>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.245]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9hX12Wex3BBg2rdS0+/97FanF51xw2
	iycLzzBZTD01gcViwcZHjA6sHjtn3WX32Pm9gd3jzIIj7B6fN8kFsERx2aSk5mSWpRbp2yVw
	ZXx/+ou54Chbxe3N9Q2Mc1i7GDk5JARMJF7NameHsMUkLtxbzwZiCwksY5Q4tcu/i5ELyO5l
	kli0ZBErhLONUeJ/9xuwDl4BNYkDv36B2SwCqhJTXl9lArHZBNQlPr/ewQ4xSU6iaclq5i5G
	Dg5RgQiJxxeEIFoFJX5MvscCYosImEs8uHMArJxZoETi+vMvYEcIA8VfzD3ABtIqJGAocW2+
	AUiYU8BIYlXzdFaIcjOJRy3rmCFseYnNa94yQ2xVlvhz+RQTxF/KEs9nHGSZwCgyC8nmWUja
	ZyFpX8DIvIpRrLQ4uaA4KT21wlivODG3uDQvXS85P3cTIyRKanYw3vtqc4hRgINRiYfXYUZH
	sBBrYllxZe4hRgkOZiUR3udHgEK8KYmVValF+fFFpTmpxYcYmTg4pRoYo7nXFWhVlaz5sTR5
	cpALI5Olra/3haJOvwLRT9Iub9OiWjaKvljDce70leYklzR+lkTmyd5zbcrLQr/bx9e926as
	y9E+xyH9zLb+7UJ3Ameyb7Vq4d3HdKxHJsY2qqxMsXTu8sht7z226dw40jc5S2xN1tOf0zri
	OdmWnJwrXi76/UtuhagSS3FGoqEWc1FxIgBz5+80cAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 07:48 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.21 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jun  2 13:47:39 2014
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.21-rc1.xz
> and the diffstat can be found below.
>
> thanks,
> js
>

Compiled and booted on my test systems. No dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
