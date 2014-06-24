Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaFXTvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:51:00 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:38851 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaFXTu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:50:58 -0400
X-AuditID: cbfec37c-b7fd06d000004f49-da-53a9d6a13ea4
Message-id: <53A9D69E.2050008@samsung.com>
Date: Tue, 24 Jun 2014 13:50:54 -0600
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
Subject: Re: [PATCH 3.15 00/61] 3.15.2-stable review
References: <20140624154952.751713761@linuxfoundation.org>
In-reply-to: <20140624154952.751713761@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.222]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX92F11YGG7zZLGkxZ/0aNovmxevZ
	LC7vmsNm8WThGSaLqacmsFgs2PiI0eJR31t2B3aPnbPusnucmPGbxWP/3DVA7vcGdo/Pm+QC
	WKO4bFJSczLLUov07RK4Mq7O3sdUcIStYucW+wbGGaxdjJwcEgImEms2bGaGsMUkLtxbz9bF
	yMUhJLCMUeLzqa1MEE4vk8SsKW9YIZxtjBIbthxkB2nhFdCSeD1tLxOIzSKgKnFozhU2EJtN
	QF3i8+sdYDVCAnISTUtWg60QFYiQOND3jBWiV1Dix+R7LCC2iECwxNqvCxlBFjALrGKUuH55
	OdggYaD7ep9/Y4QYZCWx7uBnMJtTwFpi84brYM3MAmYSj1rWMUPY8hKb17xlhqhXlvhz+RQT
	xG/KEk+mnGecwCgyC8nuWUjaZyFpX8DIvIpRrLQ4uaA4KT21wlivODG3uDQvXS85P3cTIySW
	anYw3vtqc4hRgINRiYf3wuyVwUKsiWXFlbmHGCU4mJVEeE27gUK8KYmVValF+fFFpTmpxYcY
	mTg4pRoYfV7ExVpvWmB/2DEgq3JCybZNuwvfCe7jKZS9YVTa9mq/iuW9K00/556Uj18kV39D
	ZP6PI9FiT21ZlELkrX/8u/n052fGnNmxEgd/5NUrv7B/U/uR+8wSN1O3uaZvPNId6v/3uv29
	cOrf4pjMcrvThru9HDuX5PdnTcgI/WwkorWjaY/YzR0zlFiKMxINtZiLihMBSA9bqIMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 09:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.15.2 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 26 15:49:36 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.2-rc1.gz
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
