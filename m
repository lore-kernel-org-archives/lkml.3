Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbaGPEX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:23:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51394 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933783AbaGPEXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:23:55 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C5FE57.9010404@roeck-us.net>
Date: Tue, 15 Jul 2014 21:23:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/22] 3.4.99-stable review
References: <20140715231622.121816073@linuxfoundation.org>
In-Reply-To: <20140715231622.121816073@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 04:17 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.99 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jul 17 23:16:04 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 117 pass: 111 fail: 6
Failed builds:
	alpha:allmodconfig
	arm:spear6xx_defconfig
	score:defconfig
	sparc64:allmodconfig
	unicore32:defconfig
	xtensa:allmodconfig

Qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

A note on the above link and its accessibility: I have seen relentless attacks
from various sources recently. All but one of those attacks originated from
IP addresses allocated to Chinese service providers (the one exception was
an attack from an Amazon virtual host). Attacks have become more sophisticated
over time, to a point where I no longer trust my firewalls.
For this reason, I now permanently block the entire IP address range of a
service provider if an attack originates from an address range allocated
to that provider. I understand that this may bve considered a bit drastic,
but this is my server, the information on it is provided free of charge,
for the benefit of everyone, and there should be no reason to attack it.
Blame the attackers, not me.

If you have reason to believe that your address has been blocked,
I will be happy to selectively unblock it if you can show me legitimate
interest in accessing the information.

Guenter

