Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaG0O64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 10:58:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60136 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaG0O6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 10:58:54 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53D513AB.7030109@roeck-us.net>
Date: Sun, 27 Jul 2014 07:58:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/23] 3.4.100-stable review
References: <20140726190149.723570428@linuxfoundation.org>
In-Reply-To: <20140726190149.723570428@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2014 12:02 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.100 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jul 28 19:01:37 UTC 2014.
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

Guenter

