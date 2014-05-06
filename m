Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaEFO43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:56:29 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:49747 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaEFO41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:56:27 -0400
X-AuditID: cbfec37d-b7f966d000005e7e-79-5368f819d94e
Message-id: <5368F817.1080608@samsung.com>
Date: Tue, 06 May 2014 08:56:23 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.14 000/158] 3.14.3-stable review
References: <20140504154029.975081050@linuxfoundation.org>
In-reply-to: <20140504154029.975081050@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.247]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hX12pHxnBBhvmsVrMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujK629+wFJ9gq5k2fx97AOJO1i5GTQ0LAROL9zV3MELaYxIV769m6
	GLk4hASWMUo0PT7KDuH0Mkmc272fCcLZxijx9WMDWDuvgJbEtP51TCA2i4CqxNa198FsNgF1
	ic+vd7CD2EICchJNS1YDreDgEBWIkHh8QQiiVVDix+R7LCC2iECwxNqvCxlB5jMLrGKUuH55
	ORtIQljATOL0hP2sEHOsJJo37mcBmcMpYC0xY2E5SJgZqORRyzpmCFteYvOat8wQ5coSfy6f
	YoL4TFli457bbBMYRWYhWT0LSfssJO0LGJlXMYqVFicXFCelp1aY6BUn5haX5qXrJefnbmKE
	RFLtDsb7X20OMQpwMCrx8CqsSQ8WYk0sK67MPcQowcGsJMLb8CUjWIg3JbGyKrUoP76oNCe1
	+BAjEwenVANjel7TOSY9O6GyD6U9XZlMFXqZ6VxXeI3enNrz+EF4rduEahvXi+vdnJ4u5o6+
	tfrooZWz7zKaXXul9HDKq/JI1eZvSsa7EnSi67xerWBgebq1a+7boH/ROrGvnc7tkEsM2PPv
	lZPFBsU1f1/9jntrknjZbhXzMcHzW5N1ZrWFtHRyGh/6tGiXEktxRqKhFnNRcSIAvj5dSIIC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 09:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.3 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue May  6 15:38:47 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.3-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test systems. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
