Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbaGQNZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:25:01 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:33434 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaGQNY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:24:59 -0400
X-AuditID: cbfec37c-b7fd06d000004f49-6a-53c7ceaa00b1
Message-id: <53C7CEA8.1080509@samsung.com>
Date: Thu, 17 Jul 2014 07:24:56 -0600
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
Subject: Re: [PATCH 3.10 00/44] 3.10.49-stable review
References: <20140715231646.690728348@linuxfoundation.org>
In-reply-to: <20140715231646.690728348@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.242]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hX91V544HG1zaoGgxZ/0aNovmxevZ
	LC7vmsNm8WThGSaLqacmsFgs2PiI0eJR31t2B3aPnbPusnucmPGbxWP/3DVA7vcGdo/Pm+QC
	WKO4bFJSczLLUov07RK4MjYdesxecImt4kq3dgPjYtYuRk4OCQETiW0NfcwQtpjEhXvr2boY
	uTiEBJYxSky4dZkZwullklj2t5kRwtnGKHFr1UwWkBZeAS2JGWe+MIHYLAKqEoenvgaz2QTU
	JT6/3sEOYgsJyEk0LVkNtkJUIELiQN8zVoheQYkfk++BzRERCJZY+3Uh2AJmgVWMEtcvLwe6
	g4NDWMBU4stSOYg5VhIXZ01nA7E5Bawl1q17CraLWcBM4lHLOmYIW15i85q3zBD1yhJ/Lp9i
	gnhNWWLfgzmMExhFZiFZPQtJ+ywk7QsYmVcxipUWJxcUJ6WnVhjrFSfmFpfmpesl5+duYoRE
	Us0OxntfbQ4xCnAwKvHwKsw4FizEmlhWXJl7iFGCg1lJhHdb1/FgId6UxMqq1KL8+KLSnNTi
	Q4xMHJxSDYyebi8LYwXXyh+9Ne/s+szY2MTTdyyu3Mt/bsq3r/X76o9MX7o8DTmS/s2+Z3vt
	lIjM4j33rb4Fp7XsL14mWXBIt+ast8W6DZNymssPyR+SDmhaNctqv/yizusHDQ/diDzwR2Bx
	0YovVj0vv98rzG4vaS0ymjNpQ5754hW/H2m8Zji2I2ix69dCJZbijERDLeai4kQAfs4QYIIC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 05:16 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.49 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jul 17 23:16:37 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.49-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

rc1 and rc2 compiled and booted on my test system. No dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
