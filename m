Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaENCJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 22:09:52 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:8460 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaENCJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 22:09:49 -0400
X-AuditID: cbfec37d-b7f966d000005e7e-b3-5372d06b3039
Message-id: <5372D069.7030906@samsung.com>
Date: Tue, 13 May 2014 20:09:45 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.12 000/182] 3.12.20-stable review
References: <cover.1399973152.git.jslaby@suse.cz>
In-reply-to: <cover.1399973152.git.jslaby@suse.cz>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.217]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9hX93sC0XBBv13rCw+/97FanF51xw2
	iycLzzBZTD01gcViwcZHjA6sHjtn3WX32Pm9gd3jzIIj7B6fN8kFsERx2aSk5mSWpRbp2yVw
	ZTz/uZml4BhbxcqmwAbGOaxdjJwcEgImEi0TN7FA2GISF+6tZwOxhQSWMUpc+WnexcgFZPcy
	SWx6e58RwtnGKLFx3VImkCpeAS2J9guXmEFsFgFViWNPrjGC2GwC6hKfX+9gh5gkJ9G0ZDVQ
	DQeHqECExOMLQhCtghI/Jt8DWywiYC7x4M4BsHJmgRKJ68+/gB0hDBS/NW021EGGEl//LmUE
	GcMpYCTx6rgkRLmZxKOWdcwQtrzE5jVvmSHKlSX+XD7FBPGXssT9yQdZJjCKzEKyeRaS9llI
	2hcwMq9iFCstTi4oTkpPrTDRK07MLS7NS9dLzs/dxAiJktodjPe/2hxiFOBgVOLhveFcFCzE
	mlhWXJl7iFGCg1lJhLd8C1CINyWxsiq1KD++qDQntfgQIxMHp1QDo6ktq2DS+SyPVy0rHskf
	ik5s/Rvd6JBmciblevW8z/VNCgXrrY93VH6Jzb71pLjWgrX7zsTNQpt8tA4kTi6Ys8NL56Tl
	9cPH3q5njpwZwndK/ID7jtLC/9dc/82Z7KM85XNExBqWJukJemklMupuf5dFHe3pzpTcofOK
	3bGJ52+3Z+vS+9/2KrEUZyQaajEXFScCAE7Vi+JwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 03:26 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.20 release.
> There are 182 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu May 15 09:25:52 2014
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.20-rc1.xz
> and the diffstat can be found below.
>
> thanks,
> js
>

Compiled and booted on my test system. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
