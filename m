Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaDRWMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:12:51 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:23735 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbaDRWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:12:41 -0400
X-AuditID: cbfec37d-b7f616d0000059df-17-5351a35857ee
Message-id: <5351A355.1030607@samsung.com>
Date: Fri, 18 Apr 2014 16:12:37 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.12 00/72] 3.12.18-stable review
References: <cover.1397812482.git.jslaby@suse.cz>
In-reply-to: <cover.1397812482.git.jslaby@suse.cz>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.209]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9hP92IxYHBBh+Pc1t8/r2L1eLyrjls
	Fk8WnmGymHpqAovFgo2PGB1YPXbOusvusfN7A7vHmQVH2D0+b5ILYInisklJzcksSy3St0vg
	yth45B9rwWG2is4JZ5kaGGeydjFyckgImEj0XX0KZYtJXLi3nq2LkYtDSGAZo8T1yY8ZIZxe
	Jomjn3eyQzjbGCUuNv5mB2nhFdCSaL/wFsjm4GARUJU4OiEOJMwmoC7x+fUOsBIhATmJpiWr
	mUFsUYEIiVdnJ7JAtApK/Jh8D8wWETCXeHDnAFg9s0CJxPXnX9hAbGEBU4kF8z6zgIwXEjCU
	uLBTBsTkFDCSuPxZF6LaTOJRyzpmCFteYvOat8wQW5Ul/lw+xQTxl7LExMbbLBMYRWYhWTwL
	SfssJO0LGJlXMYqVFicXFCelp1aY6BUn5haX5qXrJefnbmKExEntDsb7X20OMQpwMCrx8D6s
	CgwWYk0sK67MPcQowcGsJMJ7tQsoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgXFP+EvdiwryN910
	pL5q/fWampLhs2TNVu67kS82hnB82nRi61GO7iXJ15Ju5b6ZWeizLybqiIKDufWykwl5E0Ir
	1/EffRZ/6ODJcNtZTqFan54nSiU3Klnx91R/k9ozwce5I/Qje/yEvojNa/wSf9RzZ4u6/usI
	DQtw9+q5zGbXrZ1mq1Itq8RSnJFoqMVcVJwIALtd6JxxAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 03:21 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.18 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Apr 23 09:14:42 2014
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.18-rc1.xz
> and the diffstat can be found below.
>
> thanks,
> js
>

Compiled and booted on my system. No regressions in dmesg.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
