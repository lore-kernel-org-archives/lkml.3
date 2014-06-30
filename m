Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaF3QTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:19:23 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:35806 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaF3QTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:19:21 -0400
X-AuditID: cbfec37b-b7fbe6d000006742-a4-53b18e08dd4a
Message-id: <53B18E05.3000105@samsung.com>
Date: Mon, 30 Jun 2014 10:19:17 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.12 000/181] 3.12.24-stable review
References: <cover.1404128997.git.jslaby@suse.cz>
In-reply-to: <cover.1404128997.git.jslaby@suse.cz>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.211]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9hX12Ovo3BBls/iVh8/r2L1eLyrjls
	Fk8WnmGymHpqAovFgo2PGB1YPXbOusvusfN7A7vHmQVH2D0+b5ILYInisklJzcksSy3St0vg
	ynj7YS1TwRG2ih+7jjM2MM5m7WLk5JAQMJF4OfsLO4QtJnHh3no2EFtIYBmjRNNJni5GLiC7
	l0niY+dqdghnG6PE+0sPwbp5BbQkPh9/ywhiswioSlxt2ApmswmoS3x+vYMdYpKcRNOS1cwg
	tqhAhMSBvmdQvYISPybfYwGxRQTMJR7cOQBWzyxQInH9+RewK4SB4nve3GOEmGMocfL+cqBe
	Dg5OASOJi4vyIMrNJB61rGOGsOUlNq95ywxRrizx5/IpJojHlCWe79zJPoFRZBaSzbOQtM9C
	0r6AkXkVo1hpcXJBcVJ6aoWRXnFibnFpXrpecn7uJkZIpFTvYLz71eYQowAHoxIPr0LDxmAh
	1sSy4srcQ4wSHMxKIrw3fYBCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGNU5pLg/O4XXRvG9uSBn
	KVBpvk2BY3qpR1/46ZD/M0I0yjxrckV8vkpPPjVz7v2sC3/SJobIG+QmLb/+N6P9u5t8luvK
	2UqHVro8/3hjw8r7QX+sli5e4eF6gIHLpq3oVOSdY5IfjFNWtaVLGRqxMrveibp3O+D7ntti
	eZH5i5ySXt0tKeO2V2Ipzkg01GIuKk4EABXe07NyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 05:51 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.24 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jul  2 11:49:58 2014
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.24-rc1.xz
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
