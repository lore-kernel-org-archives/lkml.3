Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaEFO5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:57:35 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:64066 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaEFO5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:57:33 -0400
X-AuditID: cbfec37b-b7fc26d0000070ab-b8-5368f85d2415
Message-id: <5368F85A.3060307@samsung.com>
Date: Tue, 06 May 2014 08:57:30 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.12 00/50] 3.12.19-stable review
References: <cover.1399292849.git.jslaby@suse.cz>
In-reply-to: <cover.1399292849.git.jslaby@suse.cz>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.247]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9hP93YHxnBBi9fi1h8/r2L1eLyrjls
	Fk8WnmGymHpqAovFgo2PGB1YPXbOusvusfN7A7vHmQVH2D0+b5ILYInisklJzcksSy3St0vg
	ytgyYwJzwTG2itPdnA2Ms1m7GDk4JARMJPZu8+ti5AQyxSQu3FvP1sXIxSEksIxRYvXqTawQ
	Ti+TROvRbkYIZxujxIuu/ewgLbwCWhKtM74wg9gsAqoSxz7eZwOx2QTUJT6/3gFWIyQgJ9G0
	ZDUzyDZRgQiJxxeEIFoFJX5MvscCYosImEs8uHMArJxZoETi+vMvYGOEBUwlFs/Yyg7SKiRg
	KHH3nD1ImFPASGLO5vVMEOXWEisnbWOEsOUlNq95ywyxVVniz+VTTBCPKUts3HObbQKjyCwk
	m2chaZ+FpH0BI/MqRrHS4uSC4qT01AojveLE3OLSvHS95PzcTYyQKKnewXj3q80hRgEORiUe
	XoU16cFCrIllxZW5hxglOJiVRHgbvmQEC/GmJFZWpRblxxeV5qQWH2Jk4uCUamBUNmRrU25f
	sOStz+W+yvyT67dK1Ucsu58T8NGtVjK7wrGHT+vrO8kC6+OJcTpBluWPFjpLTXkX+Uh8Uov/
	kcXWE2I95MKXpvpMfnHgbU2k6PkHyrlzRB6+WVi3K9pNfW/uoUM7s3ec2XfgXdT0ZJckl5rL
	UiVzJrz2PsB2SYRxxdqaY4uE/yxQYinOSDTUYi4qTgQAeCc0knACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 06:28 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.19 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed May  7 12:27:29 2014
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.19-rc1.xz
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
